import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/discount_widget.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

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

    return StreamBuilder<bool>(
        stream: bloc.refreshPackages,
        builder: (context, enterDiscount) {
          if (bloc.packageItemNew != null)
            return enableDiscountBoxWidget();
          else
            return EmptyBox();
        });
  }

  Widget enableDiscountBoxWidget() {
    return StreamBuilder<bool>(
        stream: bloc.enterDiscount,
        builder: (context, enterDiscount) {
          if (enterDiscount.hasData && enterDiscount.requireData)
            return StreamBuilder(
                stream: bloc.usedDiscount,
                builder: (context, usedDiscount) {
                  if (usedDiscount.data==null || usedDiscount.data == false)
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
                          onTap: () {
                            bloc.setUsedDiscount = false;
                            bloc.setEnterDiscount = true;
                          },
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
        height: 10.h,
        decoration: AppDecorations.boxSmall.copyWith(
          color: Color(0xffF5F5F5),
        ),
        padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: context.textDirectionOfLocale,
          children: [
            ImageUtils.fromLocal('assets/images/bill/discount_success.svg',
                width: 10.w, height: 10.w),
            Space(
              width: 2.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: context.textDirectionOfLocale,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      '${bloc.discountInfo?.discount}'.seRagham() + ' ${intl.discount}',
                      style: typography.caption!.copyWith(fontSize: 12.sp,fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      bloc.discountInfo?.description ?? intl.discountMessage,
                      style: typography.caption!.copyWith(fontSize: 10.sp,fontWeight: FontWeight.w400),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                bloc.setUsedDiscount = false;
                bloc.setEnterDiscount = false;
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.red,
              ),
              iconSize: 5.w,
            )
          ],
        ));
  }
}
