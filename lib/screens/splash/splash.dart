import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/user/version.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/splash/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ResourcefulState<SplashScreen> {
  late SplashBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SplashBloc();
    bloc.getPackageInfo();
    bloc.getUser();

    listenBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    bloc.showUpdate.listen((event) {
      showUpdate(event);
    });
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
    });
  }

  void showUpdate(Version event) {
    DialogUtils.showDialogPage(
        context: context,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            width: double.maxFinite,
            decoration: AppDecorations.boxLarge.copyWith(
              color: AppColors.onPrimary,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title!,
                    textAlign: TextAlign.center,
                    textDirection: context.textDirectionOfLocale,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Space(height: 2.h),
                  Text(
                    event.description!,
                    textDirection: context.textDirectionOfLocale,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Space(height: 3.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 6.h,
                        width: 30.w,
                        child: SubmitButton(
                          label: intl.update,
                          onTap: () {
                            Utils.launchURL(Platform.isIOS
                                ? (bloc.packageName!
                                        .contains(FlavorConfig.instance.variables["iappsPackage"]))
                                    ? event.iapps!
                                    : event.sibapp!
                                : event.google!);
                          },
                        ),
                      ),
                      if (!bloc.forceUpdate) SizedBox(width: 2.w),
                      if (!bloc.forceUpdate)
                        FlatButton(
                          child: Text(
                            intl.later,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: AppColors.primary),
                          ),
                          onPressed: () {
                            print('later');
                            Navigator.of(context).pop();
                            VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
                          },
                          color: Colors.white,
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageUtils.fromLocal(
                    'assets/images/registry/app_logo.svg',
                    width: 30.w,
                    height: 30.w,
                  ),
                  Space(
                    height: 2.h,
                  ),
                  Text(
                    intl.appNameSplash,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: bloc.versionApp,
                builder: (context, snapshot) {
                  return Align(
                    child: Padding(
                      child: Text(
                        intl.version(snapshot.data?.toString() ?? ''),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      padding: EdgeInsets.only(bottom: 16),
                    ),
                    alignment: Alignment.bottomCenter,
                  );
                })
          ],
        ),
      ),
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
