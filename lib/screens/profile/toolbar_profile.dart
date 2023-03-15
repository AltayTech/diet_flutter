import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';

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
    return Container(
      height: 35.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Column(
        children: [
          Space(
            height: 3.h,
          ),
          Text(
           intl.profile,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 1,
            style: Theme.of(context).textTheme.headline6!.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          Space(
            height: 2.h,
          ),
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 213, 213),
              borderRadius: BorderRadius.circular(80.0),
              border: profileBloc.userInfo.media != null
                  ? Border.all(
                      color: Colors.white,
                      width: 1.w,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
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
          Space(
            height: 1.h,
          ),
          Text(
            '${profileBloc.userInfo.fullName}',
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 1,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: AppColors.onPrimary,
                ),
          ),
          Text(
            '${intl.mobile}: ${profileBloc.userInfo.mobile}',
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppColors.onPrimary,
                ),
          ),
        ],
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
