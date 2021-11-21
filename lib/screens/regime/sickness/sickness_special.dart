import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:behandam/screens/regime/sickness/sicknss_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:behandam/widget/sickness_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class SicknessSpecialScreen extends StatefulWidget {
  const SicknessSpecialScreen({Key? key}) : super(key: key);

  @override
  _SicknessSpecialScreenState createState() => _SicknessSpecialScreenState();
}

class _SicknessSpecialScreenState extends ResourcefulState<SicknessSpecialScreen>
    implements ItemClick {
  late SicknessBloc sicknessBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sicknessBloc = SicknessBloc();
    sicknessBloc.getSicknessSpecial();
    listenBloc();
  }

  void listenBloc() {
    sicknessBloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      VxNavigator.of(context).push(Uri.parse(event));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SicknessProvider(sicknessBloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.sicknessSpecial),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.white,
                child: StreamBuilder(
                    stream: sicknessBloc.waiting,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == false)
                        return Column(
                          children: [
                            SizedBox(height: 4.h),
                            Center(
                              child: Text(
                                intl.sicknessSpecialLabelUser,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            Space(height: 2.h),
                            if (sicknessBloc.userSicknessSpecial != null)
                              ...sicknessBloc.userSicknessSpecial!.specials!.map((element) {
                                return Container(
                                    height: 9.h,
                                    child: _itemWithTick(
                                      child: illItem(element),
                                      sickness: element,
                                    ));
                              }),
                            Space(height: 2.h),
                            MaterialButton(
                              onPressed: () {
                                DialogUtils.showDialogProgress(context: context);
                                sicknessBloc.sendSicknessSpecial();
                              },
                              child: Text(intl.confirmContinue),
                            )
                          ],
                        );
                      else {
                        return SpinKitCircle(
                          size: 7.w,
                          color: AppColors.primary,
                        );
                      }
                    }),
              ),
            ),
          ),
        ));
  }

  Widget illItem(SicknessSpecial sicknessSpecial) {
    String? title;
    if (sicknessSpecial.isSelected! && sicknessSpecial.children!.length > 0) {
      sicknessSpecial.children?.forEach((element) {
        if (element.isSelected!) title = sicknessSpecial.title! + " > " + element.title!;
      });
    } else
      title = sicknessSpecial.title!;
    return InkWell(
      onTap: () {
        if (sicknessSpecial.isSelected!) {
          setState(() {
            sicknessSpecial.children?.forEach((element) {
              element.isSelected = false;
            });
            sicknessSpecial.isSelected = false;
          });
        } else {
          if (sicknessSpecial.children?.length == 0) {
            setState(() {
              sicknessSpecial.isSelected = true;
            });
          } else {
            DialogUtils.showDialogPage(
                context: context,
                child: SicknessDialog(
                  items: null,
                  itemClick: this,
                  sicknessType: SicknessType.SPECIAL,
                  sicknessSpecial: sicknessSpecial,
                ));
          }
        }
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: sicknessSpecial.isSelected!
                  ? sicknessSpecial.bgColor
                  : Color.fromRGBO(246, 246, 246, 1),
              child: ClipPath(
                clipper: BottomTriangle(),
                child: Container(
                  // width: double.infinity,
                  // height: double.infinity,
                  color:
                      sicknessSpecial.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.w,
                    vertical: 3.h,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 2.h,
                    ),
                    child: Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.visible,
                      style:
                          Theme.of(context).textTheme.caption!.copyWith(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              constraints: BoxConstraints(minWidth: 30.w),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 10,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                // overflow: TextOverflow.visible,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemWithTick({
    required Widget child,
    dynamic sickness,
  }) {
    return Container(
      constraints: BoxConstraints(minWidth: 30.w),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 4,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                // padding: EdgeInsets.all(_widthSpace * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: sickness.isSelected!
                      ? [
                          BoxShadow(
                            color: sickness.shadow,
                            // color: current['shadow'],
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                          ),
                        ]
                      : null,
                ),
                child: CircleAvatar(
                  backgroundColor:
                      sickness.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                  radius: 4.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.w),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ImageUtils.fromLocal(
                        'assets/images/bill/tick.svg',
                        width: 3.w,
                        height: 3.w,
                        color: sickness.isSelected!
                            ? sickness.tick
                            : Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 6.5.h,
              margin: EdgeInsets.fromLTRB(0.5.w, 0.5.h, 0.5.w, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: sickness.isSelected!
                    ? [
                        BoxShadow(
                          color: sickness.shadow,
                          // color: current['shadow'],
                          blurRadius: 3.0,
                          spreadRadius: 2.0,
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: InkWell(
                onTap: () => setState(() {
                  if (sickness.isSelected!) {
                    sickness.isSelected = false;
                    sickness.children?.forEach((element) {
                      element.isSelected = false;
                    });
                  } else {
                    if (sickness.children?.length == 0) {
                      sickness.isSelected = true;
                    } else {
                      DialogUtils.showDialogPage(
                          context: context,
                          child: SicknessDialog(
                            sicknessSpecial: sickness,
                            itemClick: this,
                            sicknessType: SicknessType.SPECIAL,
                          ));
                    }
                  }
                }),
                child: CircleAvatar(
                  backgroundColor:
                      sickness.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
                  radius: 4.w,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ImageUtils.fromLocal(
                        'assets/images/bill/tick.svg',
                        width: 3.w,
                        height: 3.w,
                        color: sickness.isSelected!
                            ? sickness.tick
                            : Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                  ),
                ),
              ),
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
  click() {
    setState(() {});
  }

  @override
  void dispose() {
    sicknessBloc.dispose();
    super.dispose();
  }
}
