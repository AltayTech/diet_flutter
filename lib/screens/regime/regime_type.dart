import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class RegimeTypeScreen extends StatefulWidget {
  const RegimeTypeScreen({Key? key}) : super(key: key);

  @override
  _RegimeTypeScreenState createState() => _RegimeTypeScreenState();
}

class _RegimeTypeScreenState extends ResourcefulState<RegimeTypeScreen> {
  late RegimeBloc regimeBloc;
  bool check = false;
  Key? key;
  Color? colorType;
  bool disableClick = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    regimeBloc.regimeTypeMethod();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Navigator.of(context).pop();
    });

    regimeBloc.navigateToVerify.listen((regime) {

      context.vxNav.push(Uri.parse('/' + regimeBloc.path), params: regime);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.regimeReceive),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Text(
                    intl.selectYourRegime,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListOfTypes(),
                SizedBox(height: 5.h),
                Text(
                  intl.whichRegime,
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  child: ImageUtils.fromLocal('assets/images/physical_report/guide.svg',
                      width: 5.w, height: 5.h),
                  onTap: () => VxNavigator.of(context).push(Uri.parse(Routes.helpType), params: HelpPage.regimeType),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentTab: BottomNavItem.DIET,
      ),
    );
  }

  Widget ListOfTypes() {
    return StreamBuilder(
        stream: regimeBloc.itemList,
        builder: (context, AsyncSnapshot<List<RegimeType>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) => UnconstrainedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 80.w,
                          height: 9.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(30.0),
                                  topLeft: Radius.circular(30.0)),
                              color: AppColors.arcColor),
                          child: Row(
                            children: [
                              Container(
                                  width: 5.w,
                                  height: 9.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0)),
                                      color: snapshot.data![index].color)),
                              InkWell(
                                onTap: snapshot.data![index].isActiveItem
                                    ? () {
                                        snapshot.data![index].dietId =
                                            int.parse(snapshot.data![index].id!);
                                        DialogUtils.showDialogProgress(context: context);
                                        regimeBloc.pathMethod(snapshot.data![index]);
                                      }
                                    : () {
                                        Utils.getSnackbarMessage(context, intl.comingSoon);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    Container(
                                      width: 30.w,
                                      child: Text(snapshot.data![index].title!,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: !snapshot.data![index].isActiveItem
                                                  ? AppColors.strongPen
                                                  : AppColors.penColor)),
                                    ),
                                    Container(
                                      width: 30.w,
                                      child: ImageUtils.fromLocal(snapshot.data![index].icon),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
          } else {
            check = false;
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
    regimeBloc.dispose();
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

  }
}
