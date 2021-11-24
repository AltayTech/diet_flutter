import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/regime/payment/payment_bloc.dart';
import 'package:behandam/screens/regime/payment/payment_provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:sizer/sizer.dart';

class DiscountWidget extends StatefulWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  _DiscountWidgetState createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends ResourcefulState<DiscountWidget> {
  late PaymentBloc bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = PaymentProvider.of(context);
    return _discountCodeBox();
  }

  Widget _discountCodeBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(2.w),
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: context.textDirectionOfLocaleInversed,
        children: <Widget>[
          StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data == false)
                return StreamBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data == false)
                      return submitDiscountBtn();
                    else {
                      return SpinKitCircle(
                        size: 7.w,
                        color: AppColors.primary,
                      );
                    }
                  },
                  stream: bloc.discountLoading,
                );
              else {
                return ImageUtils.fromLocal(
                  'assets/images/bill/tick_circle.svg',
                  width: 7.w,
                  height: 7.w,
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(87, 206, 121, 1),
                );
              }
            },
            stream: bloc.usedDiscount,
          ),
          SizedBox(width: 4.w),
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
                  height: double.infinity,
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
          SizedBox(width: 4.w),
          ImageUtils.fromLocal(
            'assets/images/bill/gift.svg',
            fit: BoxFit.fill,
            width: 7.w,
            height: 7.w,
            color: bloc.isUsedDiscount ? Color.fromRGBO(87, 206, 121, 1) : null,
          ),
        ],
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.only(left: 1.w),
      hintStyle: Theme.of(context).textTheme.overline,
      hintText: intl.hintDiscountCode,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
    );
  }

  Widget submitDiscountBtn() {
    return GestureDetector(
      onTap: (bloc.discountCode == null || bloc.discountCode!.isEmpty)
          ? null
          : () {
              bloc.checkCode(bloc.discountCode!);
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bloc.discountCode == null || bloc.discountCode!.isEmpty
              ? Colors.grey[400]
              : bloc.isWrongDisCode
                  ? Colors.white
                  : AppColors.primaryVariantLight,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Text(
          intl.acceptCode,
          textDirection: context.textDirectionOfLocale,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: bloc.isWrongDisCode ? AppColors.primary : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
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
  void onShowMessage(String value) {}
}
