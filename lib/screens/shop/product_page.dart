import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:dio/dio.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ResourcefulState<ProductPage> {
  late ProductBloc productBloc;
  final Dio _dio = Dio();
  String? args;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc = ProductBloc();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    args = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    productBloc.getProduct(int.parse(args!));
    debugPrint('args = > $args');
  }

  @override
  Widget build(BuildContext context) {
    // productBloc.getProduct(1);
    super.build(context);
    return SafeArea(
        child: Scaffold(
            appBar: Toolbar(
              titleBar: intl.shop,
            ),
            body: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  SizedBox(height: 2.h),
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder(
                          stream: productBloc.product,
                          builder: (context, AsyncSnapshot<ShopProduct> snapshot) {
                            if (snapshot.hasData)
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    firstSection(
                                      snapshot.data!,
                                    ),
                                    secondSection(snapshot.data!),
                                  ],
                                ),
                              );
                            else
                              return Progress();
                          }))
                ]))));
  }

  Widget firstSection(ShopProduct shopProduct) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: ImageUtils.fromNetwork(
                    FlavorConfig.instance.variables["baseUrlFileShop"] +
                        shopProduct.productThambnail,
                    width: double.maxFinite,
                    height: 30.h,
                    fit: BoxFit.fill),
              ),
              // ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"] + pic),
            ),
            Text(shopProduct.productName!, style: Theme
                .of(context)
                .textTheme
                .headline6),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Line(color: AppColors.strongPen, height: 0.1.h),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(shopProduct.sellingPrice.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 10.sp)),
                      Text(shopProduct.discountPrice.toString() + intl.currency,
                          style: TextStyle(fontSize: 12.sp))
                    ],
                  ),
                  OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          foregroundColor: MaterialStateProperty.all(AppColors.redBar),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                          side: MaterialStateProperty.all(BorderSide(color: AppColors.redBar))),
                      child: shopProduct.userOrderDate == null
                          ? Row(
                        children: [
                          ImageUtils.fromLocal('assets/images/shop/add_cart.svg',
                              width: 2.w, height: 3.h),
                          SizedBox(width: 2.w),
                          Text(intl.buyCourse,
                              style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
                        ],
                      )
                          : Row(
                        children: [
                          ImageUtils.fromLocal('assets/images/shop/download.png',
                              width: 2.w, height: 3.h),
                          SizedBox(width: 2.w),
                          Text(intl.downloadAll,
                              style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondSection(ShopProduct shopProduct) {
    return Card(
      child: StreamBuilder(builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpandChild(child: Html(data: shopProduct.longDescription), arrowSize: 5.w,),
            SizedBox(height: 2.h),
            ...productBloc.lessons!
                .asMap()
                .map((index, value) =>
                MapEntry(
                    index,
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: AppColors.grey,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          4.w,
                          3.w,
                          4.w,
                          3.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(value.lessonName!),
                                    RichText(
                                        text: TextSpan(
                                            text: value.minutes.toString(),
                                            style: TextStyle(color: Colors.black),
                                            children: [
                                              WidgetSpan(
                                                  child: ImageUtils.fromLocal(
                                                      'assets/images/shop/time.svg',
                                                      color: Colors.black)),
                                            ]))
                                  ],
                                )),
                            InkWell(
                              onTap: () async {
                                Directory tempDir = await getTemporaryDirectory();
                                String tempPath = tempDir.path;
                              },
                              child: Container(
                                width: 10.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.redBar),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Center(
                                  child: ImageUtils.fromLocal(shopProduct.iconState,
                                      width: 5.w, height: 3.h, color: AppColors.redBar),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15.0),
                      //       border: Border.all(color: AppColors.redBar)
                      //   ),
                      //   child: ImageUtils.fromLocal(
                      //       'assets/images/shop/download.png'),
                      // ),
                    )))
                .values
                .toList(),
          ],
        );
      }),
    );
  }

  Widget animationsList(Widget child) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[Colors.white.withOpacity(0.1), Colors.white],
        ).createShader(bounds);
      },
      child: child,
      blendMode: BlendMode.dstATop,
    );
  }

  Widget loadMoreProgress() {
    return StreamBuilder(
      stream: productBloc.loadingMoreProducts,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return CenteredCircularProgressIndicator(
          visible: snapshot.data == true,
        );
      },
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
