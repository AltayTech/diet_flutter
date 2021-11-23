import 'package:badges/badges.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/custom_curve.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ToolbarProfile extends StatefulWidget {
  ToolbarProfile();

  @override
  State createState() => ToolbarProfileState();
}

class ToolbarProfileState extends ResourcefulState<ToolbarProfile> {
  late ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    profileBloc = ProfileProvider.of(context);
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
              height: 18.h,
              child: Container(
                color: Colors.transparent,
                child: ClipPath(
                  clipper: CustomCurve(),
                  child: Container(
                    color: AppColors.primary,
                  ),
                ),
              )),
        ),
        Positioned(
          top: 5.5.h,
          right: 21.w,
          child: Text(
            '${profileBloc.userInfo.fullName}',
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Positioned(
          top: 3.h,
          right: 4.5.w,
          child: Center(
            child: Container(
              width: 15.w,
              height: 15.w,
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
                  width: 1.w,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 3.h,
          right: 4.5.w,
          child: Center(
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 213, 213),
                borderRadius: BorderRadius.circular(20.0),
                border: profileBloc.userInfo.media != null
                    ? Border.all(
                        color: Colors.white,
                        width: 1.w,
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: profileBloc.userInfo.media != null
                    ? Image.network(
                        '${FlavorConfig.instance.variables['baseUrlFile']}${profileBloc.userInfo.media!.url}',
                        fit: BoxFit.cover,
                        width: 20.w,
                        height: 20.h,
                      )
                    : ImageUtils.fromLocal(
                        profileBloc.userInfo.gender == 0
                            ? 'assets/images/profile/female_avatar.svg'
                            : 'assets/images/profile/male_avatar.svg',
                        height: 20.h,
                        width: 20.h,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 5.h,
            left: 4.h,
            child: GestureDetector(
                onTap: () {
                  VxNavigator.of(context).push(Uri.parse(Routes.inbox));
                },
                child: Badge(
                  badgeColor: Colors.white,
                  shape: BadgeShape.circle,
                  badgeContent: StreamBuilder(
                    builder: (context, snapshot) {
                      return Text(
                        '${MemoryApp.inboxCount}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                    stream: profileBloc.inboxCount,
                  ),
                  position: BadgePosition.bottomEnd(),
                  child: Container(
                    width: 10.w,
                    height: 8.w,
                    child: ImageUtils.fromLocal(
                      'assets/images/profile/inbox_app.svg',
                      color: AppColors.primary,
                      fit: BoxFit.contain,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(3),
                  ),
                ))),
      ],
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
