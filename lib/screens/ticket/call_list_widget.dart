import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/call_item.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/call_bloc.dart';
import 'package:behandam/screens/ticket/call_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';


class CallListWidget extends StatefulWidget {
  late TicketItem ticketItem;

  CallListWidget();

  @override
  State createState() => CallListWidgetState();
}

class CallListWidgetState extends ResourcefulState<CallListWidget> {
  late CallBloc callBloc;
  late List<String> calles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    callBloc = CallProvider.of(context);
    calles = [
      intl.callNumberOne,
      intl.callNumberTwo,
      intl.callNumberThree,
      intl.callNumberFour,
      intl.callNumberFive,
      intl.callNumberSix,
      intl.callNumberSeven,
      intl.callNumberEight,
      intl.callNumberNine,
      intl.callNumberTen,
      intl.callNumberEleven,
      intl.callNumberTwelve,
      intl.callNumberThirteen,
      intl.callNumberFourteen,
      intl.callNumberFifteen,
      intl.callNumberSixteen,
      intl.callNumberSeventeen,
      intl.callNumberEighteen,
      intl.callNumberNineteen,
      intl.callNumberTwenty,
    ];
    return Column(
      children: [
        ...callBloc.call!.items!
            .asMap()
            .map((index, value) => MapEntry(
                  index,
                  callItems(index, value),
                ))
            .values
            .toList()
      ],
    );
  }

  Widget callItems(int index, CallItem value) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 3.w,
          horizontal: 3.w,
        ),
        child: Directionality(
          textDirection: context.textDirectionOfLocale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ImageUtils.fromLocal(
                        "assets/images/ticket/new_ticket.svg",
                        width: 6.w,
                        height: 6.w,
                      ),
                    ),
                    Space(width: 2.w),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          index < calles.length
                              ? calles[index]
                              : "${intl.callNumberIs}${index + 1}",
                          style: Theme.of(context).textTheme.caption,
                        )),
                        if (value.isReserve == null && !value.done!)
                          StreamBuilder(
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return SpinKitCircle(
                                   size: 7.w,
                                  color: AppColors.primary,
                                );
                              } else
                                return MaterialButton(
                                  onPressed: () {
                                    deleteDialog();
                                  },
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.redAccent,
                                        width: 0.8,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    height: 5.h,
                                    width: 25.w,
                                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                                    child: Text(
                                      intl.cancelCall,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                );
                            },
                            stream: callBloc.progressNetworkItem,
                          )
                      ],
                    )),
                    if (value.isReserve != null && value.isReserve!)
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return SpinKitCircle(
                              size: 5.w,
                              color: AppColors.primary,
                            );
                          } else
                            return MaterialButton(
                              onPressed: () {
                                updateDialog();
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.redAccent,
                                    width: 0.8,
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 5.h,
                                width: 25.w,
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: Text(
                                  intl.reserveCall,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            );
                        },
                        stream: callBloc.progressNetworkItem,
                      )
                  ],
                ),
              ),
              if (value.isReserve == null) Space(height: 1.h),
              if (value.isReserve == null)
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: (value.done!) ? Color(0xffE8FAF6) : Color(0xffF2F2FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (value.done!) ? Color(0xffE8FAF6) : Color(0xffF2F2FB),
                      width: 0.8,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.w),
                  child: Text(
                    (value.done!) ? intl.callDone : intl.callProgressLabel,
                    textAlign: TextAlign.right,
                    style: (value.done!)
                        ? TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff1DD1A1))
                        : TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff45495D)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDialog() {
    DialogUtils.showDialogPage(
        context: context,
        isDismissible: true,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  intl.callRequest,
                  textAlign: TextAlign.center,
                  textDirection: context.textDirectionOfLocale,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Space(height: 2.h),
                Text(
                  intl.addCallRequestForYou,
                  textAlign: TextAlign.center,
                  textDirection: context.textDirectionOfLocale,
                  style: Theme.of(context).textTheme.caption,
                ),
                Space(height: 3.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.h,
                        width: 30.w,
                        child: MaterialButton(
                          child: Text(
                            intl.accept,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: AppColors.primary),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            callBloc.sendCallRequest();
                          },
                          color: Colors.white,
                          elevation: 0,
                        ),
                      ),
                      flex: 1,
                    ),
                    Space(width: 2.w),
                    Expanded(
                      child: Container(
                        height: 6.h,
                        width: 30.w,
                        child: MaterialButton(
                          child: Text(
                            intl.cancel,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.white,
                          elevation: 0,
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void deleteDialog() async {
    return DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                intl.cancelCallRequest,
                textAlign: TextAlign.center,
                textDirection: context.textDirectionOfLocale,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Space(height: 2.h),
              Text(
                intl.cancelCallRequestForYou,
                textDirection: context.textDirectionOfLocale,
                style: Theme.of(context).textTheme.caption,
              ),
              Space(height: 3.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 6.h,
                      width: 30.w,
                      child: MaterialButton(
                        child: Text(
                          intl.accept,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: AppColors.primary),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          callBloc.deleteCallRequest();
                        },
                        color: Colors.white,
                        elevation: 0,
                      ),
                    ),
                    flex: 1,
                  ),
                  Space(width: 2.w),
                  Expanded(
                    child: Container(
                      height: 6.h,
                      width: 30.w,
                      child: MaterialButton(
                        child: Text(
                          intl.cancel,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        elevation: 0,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              )
            ],
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
