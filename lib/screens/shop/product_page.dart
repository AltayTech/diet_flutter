import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:path_provider/path_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ResourcefulState<ProductPage> {
  late ProductBloc productBloc;
  final Dio _dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productBloc = ProductBloc();
  }

  @override
  Widget build(BuildContext context) {
    // productBloc.getProduct(1);
    super.build(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.shop),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: productBloc.product,
                builder: (context, AsyncSnapshot<ShopProduct> snapshot) {
                  if (snapshot.hasData)
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        // if (index == snapshot.requireData.length) {
                        //   return loadMoreProgress();
                        // }
                        return Column(
                              children: [
                                firstSection(snapshot.data!.productName, snapshot.data!.productThambnail,
                                    snapshot.data!.sellingPrice, snapshot.data!.discountPrice, snapshot.data!.userOrderDate),
                                secondSection(snapshot.data!.shortDescription,snapshot.data!.longDescription,snapshot.data!.iconState),
                              ],
                            );
                      });
                  else
                    return Progress();
                }
                ))]))
    )
    );
  }

  Widget firstSection(String? title, String? pic, int? selling, int? discount, String? orderDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Card(
       shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Padding( padding: const EdgeInsets.all(8.0),
            child: ImageUtils.fromLocal('assets/images/shop/title.png',
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),),
        // ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"] + pic),
        ),
            Text(title!,
            style: Theme.of(context).textTheme.headline2),
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
                      Text(selling.toString(),
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.sp)),
                      Text(discount.toString() + intl.currency, style: TextStyle(fontSize: 12.sp))
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
                    child: orderDate == null
                      ? Row(
                          children: [
                            ImageUtils.fromLocal('assets/images/shop/add_cart.svg', width: 2.w, height: 3.h),
                            SizedBox(width: 2.w),
                            Text(intl.buyCourse,
                                style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
                          ],
                        )
                        : Row(
                          children: [
                            ImageUtils.fromLocal('assets/images/shop/download.png', width: 2.w, height: 3.h),
                            SizedBox(width: 2.w),
                            Text(intl.downloadAll,
                                style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
                          ],
                        )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondSection(String? shortDes, String? longDes, String? stateIcon) {
    return Card(
      child: StreamBuilder(
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpansionTile(
                  title: Text(intl.aboutThis),
                  subtitle:  Container(
                    height: 15.h,
                    child: ListView(
                        children:[
                          animationsList(
                              Text(shortDes!)),
                        ]),
                  ),
                  children: <Widget>[
                    Text(longDes!),
                  ]),
                SizedBox(height: 2.h),
                ListView.builder(
                    itemBuilder: (context, index){
                    return  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: AppColors.grey,
                      child:
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12,8,12,8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(productBloc.lessons![index].lessonName!),
                                RichText(text: TextSpan(
                                    text: productBloc.lessons![index].minutes.toString(),
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      WidgetSpan(
                                          child: ImageUtils.fromLocal(
                                              'assets/images/shop/time.svg',
                                              color: Colors.black)
                                      ),
                                    ]
                                ))
                              ],
                            ),
                            InkWell(
                              onTap: () async{
                                Directory tempDir = await getTemporaryDirectory();
                                String tempPath = tempDir.path;

                              },
                              child: Container(
                                width:10.w,
                                height:5.h,
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.redBar),
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Center(
                                  child: ImageUtils.fromLocal(
                                      stateIcon!,
                                      width:5.w,
                                      height:3.h,
                                      color: AppColors.redBar),
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
                    );
                  }),
            ],
          );
        }
      ),
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
