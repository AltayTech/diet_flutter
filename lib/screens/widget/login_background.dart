import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class LoginBackground extends StatefulWidget {
  final List<Widget> children;

  LoginBackground({required this.children});

  @override
  _LoginBackgroundState createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends ResourcefulState<LoginBackground> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height: 97.h,
      decoration: BoxDecoration(
          image: ImageUtils.decorationImage("assets/images/app_background.png",
              fit: BoxFit.fill)),
      child: Column(
        children: [
          Space(height: 10.h),
          showLogo(),
          Expanded(child: Column(children: widget.children)),
        ],
      ),
    );
  }

  Widget showLogo() {
    return Container(
        child: Column(children: [
      ImageUtils.fromLocal('assets/images/registry/app_logo.svg',
          width: 20.w, height: 20.w),
      Space(height: 2.h),
      Text(
        intl.appDescription,
        textAlign: TextAlign.start,
        style: typography.headline4!.copyWith(
          fontFamily: 'yekan_bold',
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
      Text(
        intl.appDescription2,
        textAlign: TextAlign.start,
        style: typography.bodyText1!.copyWith(
          fontFamily: 'yekan',
          color: Colors.black,
        ),
      )
    ]));
  }
}
