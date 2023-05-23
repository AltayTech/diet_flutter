import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CallBoxProfile extends StatefulWidget {
  CallBoxProfile();

  @override
  State<CallBoxProfile> createState() => _CallBoxProfileState();
}

class _CallBoxProfileState extends ResourcefulState<CallBoxProfile> {
  late ProfileBloc profileBloc;

  Widget _callBox() {
    return Container(
      padding: EdgeInsets.only(
        bottom: 4.h,
        top: 4.h,
        left: 5.w,
        right: 5.w,
      ),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 246, 246, 246),
            spreadRadius: 7.0,
            blurRadius: 12.0,
          ),
        ],
      ),
      child:  _callCard('${intl.mobile}: ', profileBloc.userInfo.mobile!),
    );
  }

  Widget _callCard(String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: context.textDirectionOfLocale,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.right,
          textDirection: context.textDirectionOfLocale,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(width: 1.5.w),
        Text(
          text,
          textAlign: TextAlign.right,
          textDirection: context.textDirectionOfLocale,
          style: TextStyle(
            color: (text != 'ثبت نشده') ? Color.fromARGB(255, 148, 148, 148) : Colors.redAccent,
            fontSize: (text != 'ثبت نشده') ? 14.sp : 12.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    profileBloc = ProfileProvider.of(context);
    return _callBox();
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
