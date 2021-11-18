import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/custom_curve.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logifan/widgets/space.dart';
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
        height: 18.h,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 13.h,
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
                  height: 16.h,
                  child: Stack(
                    children: <Widget>[
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
                        bottom:1.h,
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
                            child: ImageUtils.fromLocal(
                              'assets/images/profile/change_pic.svg',
//                              height: SizeConfig.blockSizeHorizontal * 3,
                              width: 6.w,
                            ),
                          ),
                        ),
                      ),
                     /* Positioned(
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
                      ),*/
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
                                child: StreamBuilder(builder: (context, snapshot) {
                                  if(snapshot.data==true){
                                    return SpinKitCircle(
                                      color: AppColors.primary,
                                      size: 4.w,
                                    );
                                  }else{
                                  return  profileBloc.userInfo.media!.url != null
                                        ? ImageUtils.fromNetwork(
                                      '${FlavorConfig.instance.variables['baseUrlFile']}${profileBloc.userInfo.media!.url}',
                                      placeholder: 'assets/images/profile/female_avatar.svg',
                                      showPlaceholder: true,
                                      fit: BoxFit.cover,
                                      width: 20.w,
                                      height: 20.w,
                                    )
                                        : ImageUtils.fromLocal(
                                      profileBloc.userInfo.gender == 0
                                          ? 'assets/images/profile/female_avatar.svg'
                                          : 'assets/images/profile/male_avatar.svg',
                                      height: 20.w,
                                      width: 20.w,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },stream: profileBloc.showProgressUploadImage,),


                              )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              DialogUtils.showBottomSheetPage(
                                  context: context,
                                  child: Container(
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12)),
                                      color: AppColors.surface,
                                    ),
                                    child: Column(
                                      children: [
                                        Space(
                                          height: 2.h,
                                        ),
                                        Text(
                                          intl.pickImage,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                        Space(
                                          height: 2.h,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            profileBloc.selectGallery();
                                          },
                                          minWidth: 80.w,
                                          height: 7.h,
                                          child: Text(
                                            intl.selectGallery,
                                            style: Theme.of(context).textTheme.caption,
                                          ),
                                        ),
                                        Line(
                                          width: 80.w,
                                          height: 0.1.h,
                                          color: AppColors.lableColor,
                                        ),
                                        MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              profileBloc.selectCamera();
                                            },
                                            minWidth: 80.w,
                                            height: 7.h,
                                            child: Text(
                                              intl.selectCamera,
                                              style: Theme.of(context).textTheme.caption,
                                            )),
                                      ],
                                    ),
                                  ));
                            },
                            // onTap: _showSelectionDialog,
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ImageUtils.fromLocal(
                                'assets/images/profile/change_pic.svg',
                                // height: SizeConfig.blockSizeHorizontal * 3,
                                width: 5.5.w,
                              ),
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
