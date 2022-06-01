import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  late String title;
  bool showLogo;

  AuthHeader({required this.title, this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    return header();
  }

  Widget header() {
    return Stack(
      clipBehavior: Clip.none, children: [
        SizedBox(
            height: showLogo ? 40.h : 25.h,
            child: MyArc(
              diameter: 100.w,
            )),
        if (showLogo)
          Positioned(
            top: 2.h,
            right: 0.0,
            left: 0.0,
            child: Center(
                child: ImageUtils.fromLocal(
              'assets/images/registry/app_logo.svg',
              width: 15.w,
              height: 15.w,
            )),
          ),
        Positioned(
          top: showLogo ? 11.h : 2.h,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text(title,
                  style: TextStyle(
                      color: AppColors.penColor,
                      fontSize: 22.0,
                      fontFamily: 'Iransans-Bold',
                      fontWeight: FontWeight.w700))),
        ),
        Positioned(
          top: showLogo ? 16.h : 8.h,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal(
              'assets/images/registry/profile_logo.svg',
              width: 25.w,
              height: 25.w,
            ),
          ),
        ),
      ],
    );
  }
}
