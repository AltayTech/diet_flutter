import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/ticket/call_bloc.dart';
import 'package:behandam/screens/ticket/call_list_widget.dart';
import 'package:behandam/screens/ticket/call_provider.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class CallTicket extends StatefulWidget {
  @override
  _CallTicketState createState() => _CallTicketState();
}

class _CallTicketState extends ResourcefulState<CallTicket> {
  late CallBloc callBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callBloc = CallBloc();
    callBloc.getCalls();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CallProvider(callBloc,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == false) {
                return content();
              } else
                return Progress();
            },
            stream: callBloc.progressNetwork,
          ),
        ));
  }

  Widget content() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Padding(
          child: Column(children: [
            Padding(
              child: Text(
                intl.descriptionCallService,
                textDirection: context.textDirectionOfLocale,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
              padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            ),
            Padding(
              child: Row(
                textDirection: context.textDirectionOfLocale,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${intl.callNumber} : ',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                    textDirection: context.textDirectionOfLocale,
                  ),
                  Text(
                    MemoryApp.userInformation?.callNumber ?? MemoryApp.userInformation!.mobile!,
                    textAlign: TextAlign.center,
                    textDirection: context.textDirectionOfLocale,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Space(width: 2.5.w),
                  MaterialButton(
                    child: Text(
                      intl.edit,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                      textDirection: context.textDirectionOfLocale,
                    ),
                    onPressed: () {
                      VxNavigator.of(context).push(Uri.parse(Routes.editProfile));
                    },
                    padding: EdgeInsets.only(top: 1.w, bottom: 1.w),
                    color: Color.fromARGB(255, 245, 245, 245),
                    elevation: 0,
                    focusColor: Color.fromARGB(255, 245, 245, 245),
                    focusElevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            ),
            StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == false) {
                  return CallListWidget();
                } else {
                  return noAccessCall();
                }
              },
              stream: callBloc.notFoundCall,
            ),
          ]),
          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
        ),
      ),
    );
  }

  Widget noAccessCall() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 16, bottom: 16),
      // padding: EdgeInsets.all(16),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 3.h,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ImageUtils.fromLocal(
                    "assets/images/diet/call-center.svg",
                    width: 15.w,
                    height: 15.w,
                    color: Color(0xff676767),
                  ),
                ),
                Space(height: 5.w),
                Text(
                  intl.noAccessCallRequest,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                )
              ])),
    );
  }

  @override
  void dispose() {
    callBloc.dispose();
    super.dispose();
  }

  @override
  void onRetryLoadingPage() {
    callBloc.getCalls();
  }
}
