import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/product_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/dialog.dart';
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

enum PaymentType{
  diet,
  shop,
}

class ShopBillPage extends StatefulWidget {
  const ShopBillPage({Key? key}) : super(key: key);

  @override
  _ShopBillPageState createState() => _ShopBillPageState();
}

class _ShopBillPageState extends ResourcefulState<ShopBillPage>
    with WidgetsBindingObserver {
  late ShopProduct? product;
  late ProductBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    bloc = ProductBloc();
    bloc.navigateToVerify.listen((event) {
      // Navigator.of(context).pop();
      if(event)
        VxNavigator.of(context).clearAndPush(Uri(path: Routes.paymentOnlineSuccess), params: PaymentType.shop);
      else
        VxNavigator.of(context).popToRoot();
    });
    bloc.onlinePayment.listen((event) {
      if (event != null) {
        bloc.mustCheckLastInvoice();
        IntentUtils.launchURL(event);
      }
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    product = ModalRoute.of(context)!.settings.arguments as ShopProduct?;
    debugPrint('product shop ${product?.toJson()}');

    return Scaffold(
      appBar: Toolbar(titleBar: intl.shop),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productBox(),
            // discount(),
            priceWithDiscount(),
            Space(height: 3.h),
            SubmitButton(
              label: intl.onlinePayment,
              onTap: product == null
                  ? null
                  : () {
                      DialogUtils.showDialogProgress(context: context);
                      bloc.onlinePaymentClick(product!.id!);
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
                : ImageUtils.fromNetwork(
                    FlavorConfig.instance.variables["baseUrlFileShop"] +
                        product!.productThambnail,
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
          type == TimeScoreType.score
              ? Icons.star
              : Icons.access_alarms_rounded,
          color: type == TimeScoreType.score
              ? Colors.yellow
              : AppColors.iconsColor,
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
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
            price(intl.productPriceWithOff,
                product?.discountPrice.toString() ?? '?'),
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
          style: typography.caption?.apply(
            fontWeightDelta: 1,
            color: AppColors.primary,
          ),
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
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        child: Row(
          children: [
            ImageUtils.fromLocal(
              'assets/images/bill/gift.svg',
              fit: BoxFit.fill,
              width: 6.w,
              height: 6.w,
            ),
            Space(width: 2.w),
            Expanded(
              child: TextFormField(
                decoration: textFieldDecoration(),
                initialValue: '',
                onChanged: (value) {},
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Space(width: 2.w),
            ImageUtils.fromLocal(
              'assets/images/bill/tick_circle.svg',
              width: 10.w,
              height: 10.w,
              fit: BoxFit.fill,
              color: AppColors.primary,
            ),
            submitDiscountBtn(),
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
      onTap: () {},
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

enum TimeScoreType {
  score,
  time,
}
