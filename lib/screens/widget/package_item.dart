import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class PackageWidget extends StatelessWidget {
  late Function() onTap;
  String title;
  late bool isSelected;
  bool? isBorder;
  bool? isOurSuggestion;
  String? description;
  String? price;
  String? finalPrice;
  double? maxHeight;

  PackageWidget(
      {required this.onTap,
      required this.title,
      required this.isSelected,
      required this.description,
      required this.price,
      required this.finalPrice,
      required this.maxHeight,
      required this.isOurSuggestion,
      required this.isBorder});

  @override
  Widget build(BuildContext context) {
    TextTheme  typography = context.typography;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isBorder!
              ? isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(maxHeight: maxHeight ?? 8.h),
        child: Container(
          margin: EdgeInsets.only(right: 16,top: 16,left: 16,bottom: 16),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                    child: ImageUtils.fromLocal(
                      isSelected
                          ? 'assets/images/physical_report/selected.svg'
                          : 'assets/images/bill/not_select.svg',
                      width: 5.w,
                      height: 5.w,
                    ),
                    alignment: Alignment.topRight,

                    height: double.maxFinite),
              ),
              Space(
                width: 2.w,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        title,
                        softWrap: false,
                        textAlign: TextAlign.start,
                        style: typography.caption!.copyWith(
                            letterSpacing: -0.02,
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        description??"",
                        softWrap: false,
                        textAlign: TextAlign.start,
                        style: typography.overline!.copyWith(color: Color(0xff454545)),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        flex:1,
                        child: Container(
                          width: double.maxFinite,
                          child: Text(
                            price??'',
                            softWrap: false,
                            textAlign: TextAlign.start,
                            style: typography.caption!.copyWith(
                                letterSpacing: -0.02,
                                color: Colors.grey,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Space(width: 2.w,),
                      Expanded(
                        flex:1,
                        child: Container(
                          width: double.maxFinite,
                          child: Text(
                            finalPrice??'',
                            softWrap: false,
                            textAlign: TextAlign.start,
                            style: typography.caption!.copyWith(
                                letterSpacing: -0.02,
                                color: AppColors.priceColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
