import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'show_modal.dart';

ADShow(BuildContext context, List<SelectedTime>? info) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: MediaQuery.of(context).size.height - 540,
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView.builder(
            shrinkWrap: false,
            itemCount: info!.length,
            itemBuilder: (_, index) {
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: info[index].adviserImage == null
                          ? ImageUtils.fromLocal('assets/images/profile/psychology.svg',
                          width: 20.w, height: 7.h)
                          : ImageUtils.fromNetwork(
                          FlavorConfig.instance.variables["baseUrlFile"] +
                              info[index].adviserImage,
                          width: 20.w,
                          height: 10.h),
                      title: Text(info[index].adviserName!),
                      subtitle: Text(
                        info[index].role!,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 25.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.help,
                            ),
                            child: Center(
                              child: Text("${info[index].duration.toString() + AppLocalizations.of(context)!.min} ",
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.redBar)),
                            ),
                          ),
                          Space(width: 5.w),
                          Container(
                            width: 25.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.stableType,
                            ),
                            child: Center(
                              child: Text("${info[index].finalPrice.toString() + AppLocalizations.of(context)!.currency} ",
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.greenRuler)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Space(height: 2.h),
                    line(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.selectYourPhoneSession, style: TextStyle(fontSize: 10.sp)),
                          Text(DateTimeUtils.dateToDetail(info[index].date!),
                              style: TextStyle(fontSize: 12.sp, color: AppColors.redBar)),
                        ],
                      ),
                    ),
                    ButtonBar(
                        buttonPadding: EdgeInsets.all(0.0),
                        alignment: MainAxisAlignment.start,
                        children: [
                          ...info[index].times!.map((item) {
                            return Padding(
                                padding: EdgeInsets.only(right: 12.0, left: 12.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    showModal(context, info[index], item);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.grey),
                                    foregroundColor: MaterialStateProperty.all(AppColors.onSurface),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0))),
                                  ),
                                  child: Text(item.startTime.toString().substring(0, 5)),
                                ));
                          }).toList(),
                        ])
                  ],
                ),
              );
            }),
      ),
    ),
  );
}