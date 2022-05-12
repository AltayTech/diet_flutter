import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/regime/package/card_package.dart';
import 'package:behandam/screens/regime/package/package_bloc.dart';
import 'package:behandam/screens/regime/package/package_provider.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    if (navigator.currentConfiguration!.path == '/reg${Routes.renewBlock}') {
      //renew
      packageType = 1;
      bloc.getPackage(packageType!);
    }
    else {
      packageType = 0;
      bloc.getPackage(packageType!);
    }
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      context.vxNav.push(Uri.parse('/${event["url"]}'), params: event["params"]);
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
    return StreamBuilder(
        stream: bloc.waiting,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == false) {
            return ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: bloc.list!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      CardPackage(bloc.list![index])),
            );
          } else {
            return Center(
                child: SpinKitCircle(
              size: 7.w,
              color: AppColors.primary,
            ));
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
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
