import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/discount_widget.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class EnableDiscountBoxWidget extends StatefulWidget {
  EnableDiscountBoxWidget({Key? key}) : super(key: key);

  @override
  State createState() => _EnableDiscountBoxWidget();
}

class _EnableDiscountBoxWidget extends ResourcefulState<EnableDiscountBoxWidget> {
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
            return StreamBuilder(
                stream: bloc.usedDiscount,
                builder: (context, usedDiscount) {
                  if (usedDiscount.hasData && usedDiscount.data == true)
                    return DiscountWidget();
                  else
                   return successBox();
                });
          return Container(
            height: 10.h,
            decoration: AppDecorations.boxSmall.copyWith(
              color: Color(0xffF5F5F5),
            ),
            padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: context.textDirectionOfLocale,
              children: [
                Space(
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: context.textDirectionOfLocale,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            intl.haveDiscountCode,
                            style: typography.caption!,
                          ),
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
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget successBox() {
    return Container(
      child: Column(
        children: [

        ],
      ),
    );
  }
}
