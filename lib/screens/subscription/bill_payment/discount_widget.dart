import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'bloc.dart';
import 'provider.dart';

class DiscountWidget extends StatefulWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  _DiscountWidgetState createState() => _DiscountWidgetState();
}

class _DiscountWidgetState extends ResourcefulState<DiscountWidget> {
  late BillPaymentBloc bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = BillPaymentProvider.of(context);
    return _discountCodeBox();
  }

  Widget _discountCodeBox() {
    return StreamBuilder(
        stream: bloc.wrongDisCode,
        builder: (context, snapshot) {
          return Container(
              decoration: AppDecorations.boxSmall.copyWith(
                color: AppColors.grey,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 1.h, bottom: 1.h),
              height: bloc.isWrongDisCode ? 13.5.h : 10.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: context.textDirectionOfLocaleInversed,
                    children: <Widget>[
                      submitDiscountBtn(),
                      Expanded(
                          child: StreamBuilder(
                        builder: (context, snapshot) {
                          return Container(
                            height: 7.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textDirection: context.textDirectionOfLocaleInversed,
                              children: <Widget>[
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
                                                color:
                                                    bloc.isWrongDisCode ? Colors.red : Colors.black,
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
                        },
                        stream: bloc.usedDiscount,
                      )),
                    ],
                  ),
                  StreamBuilder(
                      stream: bloc.wrongDisCode,
                      builder: (context, snapshot) {
                        if (snapshot.data != null && snapshot.data == true)
                          return Expanded(
                            child: Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.all(6),
                                child: Text(
                                  bloc.messageErrorCode ?? intl.errorCodeDiscount,
                                  textAlign: TextAlign.start,
                                  style: context.typography.overline!.copyWith(color: Colors.red),
                                )),
                          );
                        else
                          return EmptyBox();
                      })
                ],
              ));
        });
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.only(right: 3.w),
      hintStyle: Theme.of(context).textTheme.overline,
      hintText: intl.hintDiscountCode,
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.borderRadiusSmall
            .copyWith(topLeft: Radius.zero, bottomLeft: Radius.zero),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.borderRadiusSmall
            .copyWith(topLeft: Radius.zero, bottomLeft: Radius.zero),
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.borderRadiusSmall
            .copyWith(topLeft: Radius.zero, bottomLeft: Radius.zero),
        borderSide: BorderSide(
          color: Colors.red,
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
        height: 6.h,
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.borderRadiusSmall
              .copyWith(topRight: Radius.zero, bottomRight: Radius.zero),
          color: AppColors.primary,
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Center(
          child: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data == false)
                return Text(
                  intl.acceptCode,
                  textDirection: context.textDirectionOfLocale,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                );
              else {
                return SpinKitCircle(
                  size: 7.w,
                  color: Colors.white,
                );
              }
            },
            stream: bloc.discountLoading,
          ),
        ),
      ),
    );
  }
}
