import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class ShopBillPage extends StatefulWidget {
  const ShopBillPage({Key? key}) : super(key: key);

  @override
  _ShopBillPageState createState() => _ShopBillPageState();
}

class _ShopBillPageState extends ResourcefulState<ShopBillPage> with WidgetsBindingObserver {
  late ShopProduct? product;
  late ProductBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bloc = ProductBloc();
    bloc.navigateToRoute.listen((event) {
      // Navigator.of(context).pop();
      if (event) {
        MemoryApp.analytics!.logEvent(name: "shop_payment_success");
        VxNavigator.of(context).popToRoot();
        VxNavigator.of(context)
            .clearAndPush(Uri(path: Routes.shopPaymentOnlineSuccess), params: ProductType.SHOP);
      } else {
        VxNavigator.of(context).popToRoot();
        VxNavigator.of(context)
            .push(Uri(path: Routes.shopPaymentOnlineFail), params: ProductType.SHOP);
      }
    });
    bloc.onlinePayment.listen((event) {
      if (event != null) {
        bloc.mustCheckLastInvoice();
        IntentUtils.launchURL(event);
      }
    });
    bloc.popLoading.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('shop on resume  / ${state}');
    if (state == AppLifecycleState.resumed) {
      debugPrint('shop on resume');
      bloc.checkLastInvoice();
    }
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      product = ModalRoute.of(context)!.settings.arguments as ShopProduct?;
      bloc.setProduct(product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.shop),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productBox(),
            discount(),
            priceWithDiscount(),
            StreamBuilder(
                stream: bloc.usedDiscount,
                builder: (context, snapshot) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    shape: AppShapes.rectangleMild,
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            intl.totalAmount,
                            style: typography.caption?.apply(
                              fontWeightDelta: 1,
                              fontSizeDelta: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Space(height: 0.5.h),
                          Text(
                            '${bloc.productValue?.discountPrice.toString().seRagham()} ${intl.toman}',
                            style: typography.caption?.apply(
                              fontWeightDelta: 1,
                              fontSizeDelta: 4,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Space(height: 3.h),
            SubmitButton(
              label: intl.onlinePayment,
              onTap: product == null
                  ? null
                  : () {
                      if (!bloc.discountCode.isEmptyOrNull && !bloc.isUsedDiscount) {
                        Utils.getSnackbarMessage(context, intl.offError);
                      } else {
                        DialogUtils.showDialogProgress(context: context);
                        bloc.onlinePaymentClick(product!.id!);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget productBox() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product?.productThambnail == null
                ? ImageUtils.fromLocal(
                    'assets/images/shop/shape.png',
                    decoration: AppDecorations.boxMild,
                    // width: 30.w,
                    fit: BoxFit.fitWidth,
                  )
                : ImageUtils.fromNetwork(Utils.getCompletePathShop(product!.productThambnail),
                    decoration: AppDecorations.boxMedium,
                    width: 30.w,
                    fit: BoxFit.fill,
                  ),
            Space(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product?.productName ?? '---',
                    style: typography.caption?.apply(
                      fontSizeDelta: 1,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                  Space(height: 1.h),
                  // Row(
                  //   children: [
                  //     timeScore('13:45', TimeScoreType.time),
                  //     Space(width: 5.w),
                  //     timeScore('4.5/5', TimeScoreType.score),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeScore(String label, TimeScoreType type) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          type == TimeScoreType.score ? Icons.star : Icons.access_alarms_rounded,
          color: type == TimeScoreType.score ? Colors.yellow : AppColors.iconsColor,
          size: 5.w,
        ),
        Space(width: 1.w),
        Text(
          label,
          style: typography.caption,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget priceWithDiscount() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          children: [
            price(intl.productPrice, product?.sellingPrice.toString() ?? '?'),
            Divider(
              thickness: 0.5.w,
              color: AppColors.box,
            ),
            priceDiscount(intl.discount, product?.discount ?? '?'),
            StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true)
                  return Divider(
                    thickness: 0.5.w,
                    color: AppColors.box,
                  );
                else
                  return Container();
              },
              stream: bloc.usedDiscount,
            ),
            StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true)
                  return priceDiscount(intl.discountForYou,
                      bloc.discountInfo!.discount?.toString().seRagham() ?? '?');
                else
                  return Container();
              },
              stream: bloc.usedDiscount,
            ),
          ],
        ),
      ),
    );
  }

  Widget price(String label, String amount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: typography.caption?.apply(
              color: AppColors.labelColor,
            ),
          ),
        ),
        Space(width: 3.w),
        Text(
          amount.seRagham(),
          textDirection: TextDirection.ltr,
          style: typography.caption?.apply(
            fontWeightDelta: 1,
            color: AppColors.colorTextApp,
          ),
        ),
        Space(width: 1.w),
        Text(
          intl.currency,
          style: typography.caption?.apply(
            fontWeightDelta: 1,
            color: AppColors.colorTextApp,
          ),
        ),
      ],
    );
  }

  Widget priceDiscount(String label, String amount) {
    return Row(
      textDirection: context.textDirectionOfLocale,
      children: [
        Expanded(
          child: Text(
            label,
            style: typography.caption?.apply(
              color: AppColors.labelColor,
            ),
          ),
        ),
        Space(width: 3.w),
        Text(
          '${amount.seRagham()}',
          style: typography.caption?.apply(
            fontWeightDelta: 1,
            color: AppColors.primary,
          ),
          textDirection: TextDirection.ltr,
        ),
        Space(width: 1.w),
        Text(
          intl.currency,
          style: typography.caption?.apply(
            fontWeightDelta: 1,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget discount() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: bloc.usedDiscount,
                builder: (context, snapshot) {
                  return ImageUtils.fromLocal('assets/images/bill/gift.svg',
                      fit: BoxFit.fill,
                      width: 6.w,
                      height: 6.w,
                      color: (snapshot.hasData && snapshot.data == true)
                          ? Color.fromRGBO(87, 206, 121, 1)
                          : AppColors.iconsColor);
                }),
            Space(width: 2.w),
            Expanded(
                child: StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data == false)
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    height: 7.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: context.textDirectionOfLocaleInversed,
                      children: <Widget>[
                        StreamBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data == true) {
                              return ImageUtils.fromLocal(
                                'assets/images/bill/mark.svg',
                                fit: BoxFit.fill,
                                width: 5.w,
                                height: 5.w,
                              );
                            } else
                              return Container();
                          },
                          stream: bloc.wrongDisCode,
                        ),
                        StreamBuilder(
                          builder: (context, snapshot) {
                            return Expanded(
                              child: Directionality(
                                textDirection: context.textDirectionOfLocale,
                                child: TextFormField(
                                  decoration: textFieldDecoration(),
                                  initialValue: bloc.discountCode ?? null,
                                  onChanged: (value) {
                                    bloc.discountCode = value;
                                    bloc.changeDiscountLoading(false);
                                    bloc.changeWrongDisCode(false);
                                  },
                                  keyboardType: TextInputType.text,
                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                        color: bloc.isWrongDisCode ? Colors.red : Colors.black,
                                      ),
                                ),
                              ),
                            );
                          },
                          stream: bloc.wrongDisCode,
                        ),
                      ],
                    ),
                  );
                else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        child: Text(
                          '${bloc.discountInfo?.discount.toString().seRagham()} ${intl.yourDiscount}',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .overline!
                              .copyWith(color: Color.fromRGBO(87, 206, 121, 1)),
                        ),
                      ),
                    ),
                  );
                }
              },
              stream: bloc.usedDiscount,
            )),
            Space(width: 2.w),
            StreamBuilder(
                stream: bloc.usedDiscount,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true)
                    return ImageUtils.fromLocal(
                      'assets/images/bill/tick_circle.svg',
                      width: 6.w,
                      height: 6.w,
                      fit: BoxFit.fill,
                      color: bloc.isUsedDiscount ? Color.fromRGBO(87, 206, 121, 1) : null,
                    );
                  else {
                    return StreamBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.data == null || snapshot.data == false)
                          return submitDiscountBtn();
                        else {
                          return Progress(
                            size: 7.w,
                          );
                        }
                      },
                      stream: bloc.discountLoading,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.box,
      contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
      hintStyle: Theme.of(context).textTheme.overline,
      hintText: intl.hintDiscountCode,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
    );
  }

  Widget submitDiscountBtn() {
    return GestureDetector(
      onTap: (bloc.discountCode.isEmptyOrNull)
          ? () {}
          : () {
              bloc.checkCode(bloc.discountCode!, product!.id!);
            },
      child: Container(
        decoration: AppDecorations.boxMild.copyWith(
          color: AppColors.primary,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Text(
          intl.acceptCode,
          textDirection: context.textDirectionOfLocale,
          textAlign: TextAlign.center,
          style: typography.caption?.apply(
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  void onRetryLoadingPage() {
    bloc.setProduct(product!);
  }
}

enum TimeScoreType {
  score,
  time,
}
