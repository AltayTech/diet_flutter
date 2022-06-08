import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/call_item.dart';
import 'package:behandam/screens/ticket/call_bloc.dart';
import 'package:behandam/screens/ticket/call_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';

class CallListWidget extends StatefulWidget {
  CallListWidget();

  @override
  State createState() => CallListWidgetState();
}

class CallListWidgetState extends ResourcefulState<CallListWidget> {
  late CallBloc callBloc;
  late List<String> calles;
  bool isSendRequestReserve = false;

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
                        if (value.callType == UiCallType.Reserved) reservedTileList()
                      ],
                    )),
                    if (value.callType == UiCallType.Reserve) reserveTileList()
                  ],
                ),
              ),
              if (value.callType == UiCallType.Reserved || value.callType == UiCallType.Done)
                TextDescriptionTileCall(value.done!)
            ],
          ),
        ),
      ),
    );
  }

  Widget reserveTileList() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return SpinKitCircle(
            size: 5.w,
            color: AppColors.primary,
          );
        } else
          return MaterialButton(
            onPressed: () {
              reserveDialog();
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
    );
  }

  Widget reservedTileList() {
    return StreamBuilder(
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
                style: Theme.of(context).textTheme.caption!.copyWith(color: AppColors.primary),
              ),
            ),
          );
      },
      stream: callBloc.progressNetworkItem,
    );
  }

  Widget TextDescriptionTileCall(bool isDone) {
    return Column(
      children: [
        Space(height: 1.h),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: isDone ? Color(0xffE8FAF6) : Color(0xffF2F2FB),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDone ? Color(0xffE8FAF6) : Color(0xffF2F2FB),
              width: 0.8,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.w),
          child: Text(
            isDone ? intl.callDone : intl.callProgressLabel,
            textAlign: TextAlign.right,
            style: isDone
                ? TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff1DD1A1))
                : TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff45495D)),
          ),
        ),
      ],
    );
  }

  void reserveDialog() {
    DialogUtils.showDialogPage(
        context: context,
        isDismissible: true,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
            width: double.maxFinite,
            decoration: AppDecorations.boxLarge.copyWith(
              color: AppColors.onPrimary,
            ),
            child: ContentWidgetDialog(
              title: intl.callRequest,
              content: intl.addCallRequestForYou,
              actionButtonAccept: () {
                Navigator.of(context).pop();
                isSendRequestReserve = true;
                callBloc.sendCallRequest();
              },
              actionButtonCancel: () {
                Navigator.of(context).pop();
              },
              titleButtonAccept: intl.accept,
              titleButtonCancel: intl.cancel,
            ),
          ),
        ));
  }

  void deleteDialog() async {
    return DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: ContentWidgetDialog(
            title: intl.cancelCallRequest,
            content: intl.cancelCallRequestForYou,
            actionButtonAccept: () {
              Navigator.of(context).pop();
              isSendRequestReserve = false;
              callBloc.deleteCallRequest();
            },
            actionButtonCancel: () {
              Navigator.of(context).pop();
            },
            titleButtonAccept: intl.accept,
            titleButtonCancel: intl.cancel,
          ),
        ),
      ),
    );
  }

  @override
  void onRetryAfterNoInternet() {
    if (isSendRequestReserve) {
      callBloc.sendCallRequest();
    } else
      callBloc.deleteCallRequest();
  }
}
