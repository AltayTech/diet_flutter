import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/discount_widget.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class EnableDiscountBoxWidget extends StatefulWidget {
  EnableDiscountBoxWidget({Key? key}) : super(key: key);

  @override
  State createState() => _EnableDiscountBoxWidget();
}

class _EnableDiscountBoxWidget
    extends ResourcefulState<EnableDiscountBoxWidget> {
  late BillPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = BillPaymentProvider.of(context);

    return enableDiscountBoxWidget();
  }

  Widget enableDiscountBoxWidget() {
    return StreamBuilder<bool>(
        stream: bloc.enterDiscount,
        builder: (context, enterDiscount) {
          if (enterDiscount.hasData && enterDiscount.requireData)
            return DiscountWidget();
          return Container(
            height: 12.h,
            decoration: AppDecorations.boxSmall.copyWith(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
            padding:
                EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: context.textDirectionOfLocale,
              children: [
                Space(
                  width: 2.w,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: context.textDirectionOfLocale,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        intl.haveDiscountCode,
                        style: typography.caption!,
                      ),
                      Space(
                        width: 30.w,
                      ),
                      InkWell(
                        onTap: () => bloc.setEnterDiscount = true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.red,
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          child: Text(
                            intl.enterCode,
                            textDirection: context.textDirectionOfLocale,
                            textAlign: TextAlign.center,
                            style: typography.caption!.copyWith(color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
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