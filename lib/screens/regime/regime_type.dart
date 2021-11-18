
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<bool> activeCard = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Center(child: Text(intl.regimeReceive)),
      ),
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
                  child: SvgPicture.asset(
                      'assets/images/physical_report/guide.svg',
                      width: 5.w,
                      height: 5.h),
                  onTap: () =>
                      VxNavigator.of(context).push(Uri.parse(Routes.helpType)),
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
                itemBuilder: (BuildContext context, int index) =>
                    UnconstrainedBox(
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
                            color: AppColors.arcColor
                          ),
                          child: Row(
                            children: [
                              Container(
                              width: 5.w,
                              height: 9.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),
                                  color: colorType != null
                                      ? colorType
                                      : AppColors.looseType)),
                              InkWell(
                                onTap: activeCard[index]
                                    ? () => {
                                  print('act:${activeCard[index]}'),
                                  snapshot.data![index].dietId = int.parse(snapshot.data![index].id!),
                                          regimeBloc.pathMethod(snapshot.data![index]),
                                        }
                                    : () => {
                                          Utils.getSnackbarMessage(
                                              context, 'به زودی'),
                                        },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      children: [
                                        Container(
                                          width: 30.w,
                                          child: Text(snapshot.data![index].title!,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                  color: snapshot.data![index]
                                                              .isActive! ==
                                                          '0'
                                                      ? AppColors.strongPen
                                                      : AppColors.penColor)),
                                        ),
                                        Container(
                                          width: 30.w,
                                          child: setContent(
                                              snapshot.data![index].alias!,
                                              snapshot.data![index].isActive!,
                                              index),
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
                child: Container(
                    width: 15.w,
                    height: 15.w,
                    child: CircularProgressIndicator(
                        color: Colors.grey, strokeWidth: 1.0)));
          }
        });
  }

  Widget setContent(String type, String active, int index) {
    switch (type) {
      case "WEIGHT_LOSS":
        {
          colorType = AppColors.looseType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/loose_weight.svg');
        }
      case "WEIGHT_GAIN":
        {
          colorType = AppColors.gainType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }
      case "STABILIZATION":
        {
          colorType = AppColors.stableType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "DIABETES":
        {
          colorType = AppColors.diabetType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/diabetes_diet.svg');
        }
      case "PREGNANCY":
        {
          colorType = AppColors.pregnantType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/pregnant_diet.svg');
        }
      case "KETOGENIC":
        {
          colorType = AppColors.ketoType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "SPORTS":
        {
          colorType = AppColors.sportType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/fix_weight.svg');
        }
      case "NOTRICA":
        {
          colorType = AppColors.notricaType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }
      default:
        {
          colorType = AppColors.gainType;
          if (active == '1') activeCard[index] = true;
          return SvgPicture.asset('assets/images/diet/gain_weight.svg');
        }
    }
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
