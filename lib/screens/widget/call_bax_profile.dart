import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class CallBoxProfile extends StatefulWidget {
  CallBoxProfile();

  @override
  State<CallBoxProfile> createState() => _CallBoxProfileState();
}

class _CallBoxProfileState extends ResourcefulState<CallBoxProfile> {
  late ProfileBloc profileBloc;

  Widget _callBox() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(width: double.infinity, height: 38.h),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              bottom: 8.h,
              top: 4.h,
              left: 5.w,
              right: 5.w,
            ),
            height: 35.h,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: context.textDirectionOfLocale,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _callCard('شماره موبایل : ', profileBloc.userInfo.mobile!),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  height: 0.5.h,
                  color: Color.fromARGB(255, 237, 237, 237),
                ),
                Expanded(
                  flex: 1,
                  child:
                      _callCard('شماره تماس دوم: ', profileBloc.userInfo.callNumber ?? intl.notRegister),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  height: 0.5.h,
                  color: Color.fromARGB(255, 237, 237, 237),
                ),
                Expanded(
                  flex: 1,
                  child: _callCard('شماره واتساپ : ',
                      profileBloc.userInfo.socialMedia!.length>0 ? profileBloc.userInfo.socialMedia![0].pivot!.link ?? intl.notRegister :intl.notRegister),
                ),
                Container(
                  width: double.maxFinite,
                  height: 0.5.h,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  color: Color.fromARGB(255, 237, 237, 237),
                ),
                Expanded(
                  flex: 1,
                  child: _callCard('شماره اسکایپ : ',
                      profileBloc.userInfo.socialMedia!.length>0 ? profileBloc.userInfo.socialMedia![2].pivot!.link ?? intl.notRegister:intl.notRegister),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0,
          left: 0,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.white,
              ),
              width: 12.w,
              height: 12.w,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color.fromARGB(255, 243, 243, 243),
                  ),
                  width: 9.w,
                  height: 9.w,
                  child: Center(
                    child: Icon(
                      Icons.call,
                      color: Color.fromARGB(255, 204, 204, 204),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          left: 16,
          child: Center(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color.fromARGB(255, 243, 243, 243),
                    ),
                    child: Text(
                      'ویرایش',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                VxNavigator.of(context).push(Uri.parse(Routes.editProfile));
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _callCard(String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
