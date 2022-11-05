import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/regime/package/card_package.dart';
import 'package:behandam/screens/regime/package/package_bloc.dart';
import 'package:behandam/screens/regime/package/package_provider.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../regime_bloc.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({Key? key}) : super(key: key);

  @override
  _PackageListScreenState createState() => _PackageListScreenState();
}

class _PackageListScreenState extends ResourcefulState<PackageListScreen> {
  late PackageBloc bloc;

  int? packageType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = PackageBloc();
    bloc.getPackage();

    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      context.vxNav
          .push(Uri.parse('/${event["url"]}'), params: event["params"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PackageProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.selectPackageToolbar),
          body: content(),
        ));
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 80.h,
          ),
          decoration: AppDecorations.boxSmall.copyWith(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Text(
                  intl.selectPackage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              listOfPackage(),
              Space(height: 1.h),
              Center(
                child: GestureDetector(
                  onTap: () => VxNavigator.of(context).push(
                      Uri.parse(Routes.helpType),
                      params: HelpPage.packageType),
                  child: Text(
                    intl.differentPackages,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.labelTextColor),
                  ),
                ),
              ),
              Space(height: 1.h),
              GestureDetector(
                onTap: () => VxNavigator.of(context).push(
                    Uri.parse(Routes.helpType),
                    params: HelpPage.packageType),
                child: Center(
                  child: ImageUtils.fromLocal(
                    'assets/images/diet/guide_icon.svg',
                    height: 10.w,
                    width: 10.w,
                  ),
                ),
              ),
              Space(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOfPackage() {
    return StreamBuilder<bool>(
        initialData: true,
        stream: bloc.waiting,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return bloc.list != null && bloc.list!.length > 0
                ? ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bloc.list!.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CardPackage(bloc.list![index])),
                  )
                : Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 10.h,
                    child: Center(
                        child: Text(intl.packageNotAvailable,
                            style: typography.caption)),
                  );
          } else {
            return Center(child: Progress());
          }
        });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
    bloc.setRepository();
    bloc.getPackage();
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
