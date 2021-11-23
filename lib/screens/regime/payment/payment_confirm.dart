import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/payment.dart';
import 'package:behandam/screens/regime/payment/discount_widget.dart';
import 'package:behandam/screens/regime/payment/payment_bloc.dart';
import 'package:behandam/screens/regime/payment/payment_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class PaymentConfirmScreen extends StatefulWidget {
  const PaymentConfirmScreen({Key? key}) : super(key: key);

  @override
  _PaymentConfirmScreenState createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends ResourcefulState<PaymentConfirmScreen> {
  late PaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = PaymentBloc();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();

    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.paymentSuccess),
          body: StreamBuilder(
            stream: bloc.waiting,
            builder: (context, snapshot) {
              return content();
             /* if (snapshot.hasData && snapshot.data == false) {
                return content();
              } else {
                return SpinKitCircle(
                  size: 7.w,
                  color: AppColors.primary,
                );
              }*/
            },
          ),
        ));
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 80.h,
          ),
          decoration: AppDecorations.boxSmall.copyWith(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Space(
                height: 2.h,),
                ImageUtils.fromLocal(
                  'assets/images/bill/success_pay.svg',
                  width: 40.w,
                  height: 50.w,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(height: 3.h),
                Row(
                  textDirection: context.textDirectionOfLocaleInversed,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      intl.paymentSuccessLabel,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.headline6!.copyWith(color: AppColors.primaryVariantLight),
                    ),
                    SizedBox(width: 3.w),
                    ImageUtils.fromLocal(
                      'assets/images/bill/happy_face.svg',
                      width: 7.w,
                      height: 7.w,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              Space(height: 2.h,),
              Directionality(
                textDirection: context.textDirectionOfLocale,
                child: FlatButton.icon(
                  padding: EdgeInsets.symmetric(
                    vertical: 3.h,
                    horizontal: 3.w,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: Color.fromRGBO(178, 178, 178, 1),
                        width: 0.2.w,
                      )),
                  onPressed: () {},
                  icon: ImageUtils.fromLocal(
                    'assets/images/bill/info.svg',
                    width: 7.w,
                    height: 7.w,
                  ),
//                  Icon(
//                    Icons.refresh,
//                    size: (_widthSpace / 100) * 7,
//                    color: Color.fromRGBO(178, 178, 178, 1),
//                  ),
                  label: Text(
                    'اطلاعات پرداخت',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              Space(height:7.h),
              Text(
                'برای استفاده از برنامه غذایی، بقیه مراحل دریافت رژیم رو تکمیل کن',
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption!.copyWith(color: AppColors.labelTextColor),
              ),
              Space(height:3.h),
              SubmitButton(label: intl.confirmContinue, onTap: (){})
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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

  }
}
