import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_video.dart';
import 'package:chewie/chewie.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends ResourcefulState<ProductPage> {
  late ProductBloc productBloc;

  String? args;
  late ExpandableController _controller;
  bool isInit = false;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    productBloc = ProductBloc();
    listenBloc();
    _controller = ExpandableController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments as String;
      productBloc.getProduct(int.parse(args!));
    }
  }

  void listenBloc() {
    productBloc.popLoading.listen((event) {
      Navigator.pop(context);
    });

    productBloc.navigateToRoute.listen((event) {
      if (event.toString().contains('freeProduct')) {
        // refresh page
        productBloc.getProduct(int.parse(args!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // productBloc.getProduct(1);
    super.build(context);
    return StreamBuilder(
        stream: productBloc.toolbarStream,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: Toolbar(
                titleBar: productBloc.toolbar ?? intl.myProduct,
              ),
              body: SafeArea(
                child: TouchMouseScrollable(
                  child: SingleChildScrollView(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                return Container(height: 80.h, child: Progress());
                            }))
                  ])),
                ),
              ));
        });
  }

  Widget firstSection(ShopProduct shopProduct) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: ImageUtils.fromNetwork(
                    Utils.getCompletePathShop(shopProduct.productThambnail),
                    width: double.maxFinite,
                    height: 30.h,
                    fit: BoxFit.fill),
              ),
              // ImageUtils.fromNetwork(FlavorConfig.instance.variables["baseUrlFile"] + pic),
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Text(
                shopProduct.productName!,
                style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.end,
                softWrap: true,
                textDirection: context.textDirectionOfLocale,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, left: 12.0),
              child: Line(color: AppColors.strongPen, height: 0.1.h),
            ),
            if (shopProduct.userOrderDate.isNullOrEmpty)
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
                        int.parse(shopProduct.discountPrice.toString()) == 0
                            ? Text(intl.free, style: TextStyle(fontSize: 12.sp))
                            : Text(shopProduct.discountPrice.toString() + intl.currency,
                                style: typography.caption!.copyWith(fontSize: 12.sp))
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (int.parse(shopProduct.discountPrice.toString()) == 0) {
                          DialogUtils.showDialogProgress(context: context);
                          productBloc.freePaymentClick(shopProduct.id!);
                        } else {
                          VxNavigator.of(context)
                              .push(Uri(path: Routes.shopBill), params: shopProduct);
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(40.w, 6.h)),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(AppColors.primary),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                        side: MaterialStateProperty.all(BorderSide(color: AppColors.primary)),
                      ),
                      child: Text(intl.addCourse,
                          style: typography.button!.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget secondSection(ShopProduct shopProduct) {
    return Container(
      constraints: BoxConstraints(minHeight: (productBloc.lessons!.length * 12.h)),
      child: Card(
        child: StreamBuilder(builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExpandableNotifier(
                  child: ExpandablePanel(
                    collapsed: Html(
                      data: shopProduct.shortDescription,
                      style: {
                        'p': Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                        'body': Style(fontSize: FontSize.large, fontWeight: FontWeight.w500)
                      },
                    ),
                    expanded: Html(
                      data: '<body>${shopProduct.longDescription}</body>',
                      style: {
                        'p': Style(fontSize: FontSize.large, fontWeight: FontWeight.bold),
                        'body': Style(fontSize: FontSize.large, fontWeight: FontWeight.w500)
                      },
                    ),
                    controller: _controller,
                  ),
                  initialExpanded: true,
                ),
                GestureDetector(
                  child: Text(
                    _controller.expanded ? intl.close : intl.viewAll,
                    style: Theme.of(context).textTheme.overline!.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      _controller.toggle();
                    });
                  },
                ),
                SizedBox(height: 2.h),
                ...productBloc.lessons!
                    .asMap()
                    .map((index, value) => MapEntry(
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
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.lessonName!,
                                          style: Theme.of(context).textTheme.subtitle2,
                                        ),
                                        Row(
                                          textDirection: context.textDirectionOfLocale,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ImageUtils.fromLocal('assets/images/shop/time.svg',
                                                color: Colors.black),
                                            Space(
                                              width: 1.w,
                                            ),
                                            Text(
                                              '${value.minutes} ',
                                              style: Theme.of(context).textTheme.overline,
                                            ),
                                            Space(
                                              width: 1.w,
                                            ),
                                            Text(
                                              intl.min,
                                              style: Theme.of(context).textTheme.overline,
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                StreamBuilder(
                                  builder: (context, AsyncSnapshot<TypeMediaShop> snapshot) {
                                    debugPrint('snapshot.data!= > ${value.toJson()}');
                                    switch (value.typeMediaShop) {
                                      case TypeMediaShop.lock:
                                        return InkWell(
                                          onTap: () async {},
                                          child: Container(
                                            width: 10.w,
                                            height: 5.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.primary),
                                                borderRadius: BorderRadius.circular(15.0)),
                                            child: Center(
                                              child: ImageUtils.fromLocal(
                                                  Utils.productIcon(value.typeMediaShop),
                                                  width: 5.w,
                                                  height: 3.h,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                        );
                                      case TypeMediaShop.play:
                                        return InkWell(
                                          onTap: () async {
                                            dialogVideo(value);
                                          },
                                          child: Container(
                                            width: 10.w,
                                            height: 5.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: AppColors.primary),
                                                borderRadius: BorderRadius.circular(15.0)),
                                            child: Center(
                                              child: ImageUtils.fromLocal(
                                                  Utils.productIcon(TypeMediaShop.play),
                                                  width: 5.w,
                                                  height: 3.h,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                        );
                                      case TypeMediaShop.downloadAndPlay:
                                        return Expanded(
                                            flex: 1,
                                            child: Row(
                                              textDirection: context.textDirectionOfLocale,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    dialogVideo(value);
                                                  },
                                                  child: Container(
                                                    width: 10.w,
                                                    height: 5.h,
                                                    decoration: BoxDecoration(
                                                        border:
                                                            Border.all(color: AppColors.primary),
                                                        borderRadius: BorderRadius.circular(15.0)),
                                                    child: Center(
                                                      child: ImageUtils.fromLocal(
                                                          Utils.productIcon(TypeMediaShop.play),
                                                          width: 5.w,
                                                          height: 3.h,
                                                          color: AppColors.primary),
                                                    ),
                                                  ),
                                                ),
                                                Space(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    productBloc.downloadFile(value);
                                                  },
                                                  child: Container(
                                                    width: 10.w,
                                                    height: 5.h,
                                                    decoration: BoxDecoration(
                                                        border:
                                                            Border.all(color: AppColors.primary),
                                                        borderRadius: BorderRadius.circular(15.0)),
                                                    child: Center(
                                                      child: ImageUtils.fromLocal(
                                                          Utils.productIcon(value.typeMediaShop),
                                                          width: 5.w,
                                                          height: 3.h,
                                                          color: AppColors.primary),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));

                                      default:
                                        return Progress(
                                          size: 3.w,
                                        );
                                    }
                                    ;
                                  },
                                  stream: productBloc.typeMediaShop,
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
            ),
          );
        }),
      ),
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

  void dialogVideo(Lessons lessons) {
    DialogUtils.showDialogPage(
        context: context,
        isDismissible: false,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            width: double.maxFinite,
            decoration: AppDecorations.boxLarge.copyWith(
              color: AppColors.onPrimary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: AppDecorations.boxSmall.copyWith(
                          color: AppColors.primary.withOpacity(0.4),
                        ),
                        padding: EdgeInsets.all(1.w),
                        child: Icon(
                          Icons.close,
                          size: 6.w,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  lessons.lessonName!,
                  style: typography.bodyText2,
                  textAlign: TextAlign.center,
                ),
                Space(height: 2.h),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CustomVideo(
                    url: lessons.typeMediaShop == TypeMediaShop.play ? lessons.path : lessons.video,
                    image: null,
                    isFile: lessons.typeMediaShop == TypeMediaShop.play ? true : null,
                    isLooping: false,
                    isStart: false,
                    callBackListener: (controller) {
                      _chewieController = controller;
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget addCourseBox(ShopProduct shopProduct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(shopProduct.sellingPrice.toString(),
                style: typography.caption!.copyWith(
                    decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 10.sp)),
            Text(intl.free, style: typography.caption!.copyWith(fontSize: 12.sp))
          ],
        ),
        OutlinedButton(
          onPressed: () {
            VxNavigator.of(context).push(Uri(path: Routes.shopBill), params: shopProduct);
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(40.w, 6.h)),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(AppColors.primary),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            side: MaterialStateProperty.all(BorderSide(color: AppColors.primary)),
          ),
          child: Text(intl.addCourse, style: typography.button!.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    productBloc.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  void onRetryAfterNoInternet() {
    productBloc.setRepository();
  }

  @override
  void onRetryLoadingPage() {
    productBloc.setRepository();
    productBloc.getProduct(int.parse(args!));
  }
}
