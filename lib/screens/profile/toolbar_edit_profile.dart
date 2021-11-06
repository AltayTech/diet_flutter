import 'package:badges/badges.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/CustomCurve.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ToolbarEditProfile extends StatefulWidget {
  ToolbarEditProfile();

  @override
  State createState() => ToolbarEditProfileState();
}

class ToolbarEditProfileState extends ResourcefulState<ToolbarEditProfile> {
  late ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    profileBloc = ProfileProvider.of(context);
    return Container(
        height: 22.h,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 18.h,
                color: Colors.transparent,
                child: ClipPath(
                  clipper: CustomCurve(),
                  child: Container(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  height: 22.h,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 4.h,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 250, 213, 213),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 250, 213, 213),
                                  spreadRadius: 3.0,
                                  blurRadius: 5.0,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 0.3.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1.h,
                        right: 10.w,
                        left: 10.w,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 250, 213, 213),
                                  spreadRadius: 3.0,
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/images/profile/change_pic.svg',
                              alignment: Alignment.center,
                              semanticsLabel: 'add picture',
//                              height: SizeConfig.blockSizeHorizontal * 3,
                              width: 6.w,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        bottom: 0.0,
                        right: 0.0,
                        left: 0.0,
                        child: ClipPath(
                          clipper: CustomCurve(),
                          child: Container(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2.h,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 250, 213, 213),
                                borderRadius: BorderRadius.circular(20.0),
                                border: profileBloc.userInfo.media != null
                                    ? Border.all(
                                  color: Colors.white,
                                  width: 0.1.w,
                                )
                                    : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: profileBloc.userInfo.media!.url != null
                                    ? Image.network(
                                  '${FlavorConfig.instance.variables['baseUrlFile']}${profileBloc.userInfo.media!.url}',
                                  fit: BoxFit.cover,
                                  width: 20.w,
                                  height: 20.w,
                                )
                                    : SvgPicture.asset(
                                  profileBloc.userInfo.gender == 0
                                      ? 'assets/images/profile/female_avatar.svg'
                                      : 'assets/images/profile/male_avatar.svg',
                                  alignment: Alignment.center,
                                  semanticsLabel: 'item icon',
                                  height: 20.w,
                                  width: 20.w,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: GestureDetector(
                            // onTap: _showSelectionDialog,
                            // onTap: _showSelectionDialog,
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/profile/change_pic.svg',
                                alignment: Alignment.center,
                                semanticsLabel: 'item icon',
                                // height: SizeConfig.blockSizeHorizontal * 3,
                                width: 7.5.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 7.h,
                        right: context.isRtl ? 5.w : null,
                        left: context.isRtl ? null : 5.w,
                        child: Container(
                          padding: EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 10.w,
                          height: 10.w,
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              print('onPressed back');
                             // VxNavigator.of(context).pop();
                              VxNavigator.of(context).pop();
                            },
                            alignment: Alignment.center,
                            iconSize: 6.w,
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              textDirection: context.textDirectionOfLocale,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
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
}
