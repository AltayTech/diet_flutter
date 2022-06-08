import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/screens/psychology/calendar_provider.dart';
import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logifan/widgets/space.dart';

import 'show_modal.dart';

class ADShow extends StatefulWidget {
  const ADShow({Key? key}) : super(key: key);

  @override
  _ADShowState createState() => _ADShowState();
}

class _ADShowState extends ResourcefulState<ADShow> {
  late CalenderBloc calendarBloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    calendarBloc = CalendarProvider.of(context);
    return aDShow(calendarBloc.advisersPerDay);
  }

  Widget aDShow(List<SelectedTime>? info) {
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
                  shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.borderRadiusDefault),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: info[index].adviserImage == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: ImageUtils.fromLocal(
                                      'assets/images/profile/psychology.svg',
                                      width: 20.w,
                                      fit: BoxFit.fill,
                                      height: 7.h),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: ImageUtils.fromNetwork(
                                      FlavorConfig.instance.variables["baseUrlFile"] +
                                          info[index].adviserImage,
                                      width: 20.w,
                                      fit: BoxFit.fill,
                                      height: 20.w),
                                ),
                          title: Text(
                            info[index].adviserName!,
                            style: typography.titleMedium,
                          ),
                          subtitle: Text(
                            info[index].role!,
                            style: typography.caption!.copyWith(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
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
                                  child: Text(
                                      "${info[index].duration.toString() + AppLocalizations.of(context)!.min} ",
                                      style: typography.caption!.copyWith(color: AppColors.redBar)),
                                ),
                              ),
                              Space(width: 3.w),
                              Container(
                                width: 25.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppColors.stableType,
                                ),
                                child: Center(
                                  child: Text(
                                      "${info[index].finalPrice.toString() + AppLocalizations.of(context)!.currency} ",
                                      style: typography.caption!
                                          .copyWith(color: AppColors.greenRuler)),
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
                              Text(AppLocalizations.of(context)!.selectYourPhoneSession,
                                  style: typography.overline!.copyWith(fontSize: 10.sp)),
                              Text(DateTimeUtils.dateToDetail(info[index].date!),
                                  style: typography.overline!.copyWith(color: AppColors.redBar)),
                            ],
                          ),
                        ),
                        ButtonBar(
                            buttonPadding: EdgeInsets.all(0.0),
                            alignment: MainAxisAlignment.start,
                            children: [
                              ...info[index].times!.map((item) {
                                return Padding(
                                    padding: EdgeInsets.only(right: 8.0, left: 8.0),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        showModal(context, info[index], item);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(AppColors.grey),
                                        foregroundColor:
                                            MaterialStateProperty.all(AppColors.onSurface),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0))),
                                      ),
                                      child: Text(item.startTime.toString().substring(0, 5)),
                                    ));
                              }).toList(),
                            ])
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
