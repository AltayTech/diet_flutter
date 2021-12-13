import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:behandam/screens/regime/sickness/sicknss_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
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

class SicknessScreen extends StatefulWidget {
  const SicknessScreen({Key? key}) : super(key: key);

  @override
  _SicknessScreenState createState() => _SicknessScreenState();
}

class _SicknessScreenState extends ResourcefulState<SicknessScreen> implements ItemClick {
  late SicknessBloc sicknessBloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    sicknessBloc = SicknessBloc();
    sicknessBloc.getSickness();
    listenBloc();
  }

  void listenBloc() {
    sicknessBloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      VxNavigator.of(context).push(Uri.parse(event));
    });
    sicknessBloc.showServerError.listen((event) {
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SicknessProvider(sicknessBloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.sickness),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                padding: EdgeInsets.all(4.w),
                color: Colors.white,
                child: StreamBuilder(
                    stream: sicknessBloc.waiting,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == false) {
                        controller.text = sicknessBloc.userSickness?.sicknessNote ?? '';
                        return Column(
                          children: [
                            Space(height: 2.h),
                            Center(
                              child: Text(
                                intl.sicknessLabelUser,
                                textDirection: context.textDirectionOfLocale,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption,
                              ),
                            ),
                            Space(height: 2.h),
                            if (sicknessBloc.userSickness != null)
                              ...sicknessBloc.userSickness!.sickness_categories!
                                  .map((element) {
                                return _sicknessPartBox(element);
                              }),
                            Space(height: 2.h),
                            textInput(
                                height: 20.h,
                                validation: () {},
                                label: intl.sicknessDescriptionUser,
                                textController: controller,
                                // value: sicknessBloc.userSickness!.sicknessNote,
                                onChanged: (value) {
                                  sicknessBloc.userSickness!.sicknessNote =
                                      value;
                                },
                                enable: true,
                                maxLine: true,
                                ctx: context,
                                textInputType: TextInputType.multiline,
                                textDirection: context.textDirectionOfLocale),
                            Space(height: 4.h),
                            SubmitButton(
                              onTap: () {
                                DialogUtils.showDialogProgress(
                                    context: context);
                                sicknessBloc.sendSickness();
                              },
                              label: intl.confirmContinue,
                            ),
                            Space(height: 3.h),
                          ],
                        );
                      }else {
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

  Widget _sicknessPartBox(CategorySickness sickness) {
    var index = sicknessBloc.userSickness!.sickness_categories
        ?.indexWhere((element) => element == sickness);
    return sickness.sicknesses != null && sickness.sicknesses!.length > 0
        ? Column(
            children: [
              _illBox(
                sickness,
                Color.fromRGBO(230, 244, 254, 1),
              ),
              if (index != sicknessBloc.userSickness!.sickness_categories!.length - 1)
                Space(height: 0.5.h),
              if (index != sicknessBloc.userSickness!.sickness_categories!.length - 1)
                Divider(height: 1.h),
              if (index != sicknessBloc.userSickness!.sickness_categories!.length - 1)
                Space(height: 1.h),
            ],
          )
        : Container();
  }

  Widget _illBox(CategorySickness categorySickness, Color iconBg) {
    return Column(
      textDirection: context.textDirectionOfLocale,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _titleBox(categorySickness.title!, iconBg),
        Space(height: 1.h),
        if (categorySickness.sicknesses != null && categorySickness.sicknesses!.length > 0)
          Container(
            height: 9.h,
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                  stops: [0.0, 0.1, 0.8, 1.0], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (index == 0) Space(width: 5.w),
                        _itemWithTick(
                          child: illItem(categorySickness.sicknesses![index], categorySickness),
                          sickness: categorySickness.sicknesses![index],
                          current: categorySickness,
                          index: index,
                        ),
                        if (index == categorySickness.sicknesses!.length - 1) Space(width: 5.w),
                      ],
                    );
                  },
                  itemCount: categorySickness.sicknesses!.length,
                  separatorBuilder: (ctx, index) => Space(
                    width: 0.02.w,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget illItem(CategorySickness current, CategorySickness categorySickness) {
    String? title;
    if (current.isSelected! && current.children!.length > 0) {
      current.children?.forEach((element) {
        if (element.isSelected!) title = current.title! + " > " + element.title!;
      });
    } else
      title = current.title!;
    return InkWell(
      onTap: () {
        print('InkWell');
        if (current.isSelected!) {
          setState(() {
            current.children?.forEach((element) {
              element.isSelected = false;
            });
            current.isSelected = false;
          });
        } else {
          if (current.children?.length == 0) {
            print('children');
            setState(() {
              current.isSelected = true;
            });
          } else {
            print('dialog');
            DialogUtils.showDialogPage(
                context: context,
                child: Center(
                  child: Container(child: SicknessDialog(
                    items: current,
                    itemClick: this,
                    sicknessType: SicknessType.NORMAL,
                  ),
                  height: 60.h,),
                ));
          }
        }
      },
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color:
                  current.isSelected! ? categorySickness.bgColor : Color.fromRGBO(246, 246, 246, 1),
              // width: double.infinity,
              // height: SizeConfig.blockSizeVertical * 5,
              child: ClipPath(
                clipper: BottomTriangle(),
                child: Container(
                  // width: double.infinity,
                  // height: double.infinity,
                  color: current.isSelected! ? Colors.white : Color.fromRGBO(239, 239, 239, 1),
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

  Widget _titleBox(String title, Color iconBg) {
    return Padding(
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: Text(
        title,
        textDirection: context.textDirectionOfLocale,
        style: typography.caption?.apply(
          fontWeightDelta: 1,
          fontSizeDelta: 1
        ),
      ),
    );
  }

  Widget _itemWithTick(
      {required Widget child,
      required CategorySickness current,
      dynamic sickness,
      required int index}) {
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
                            color: current.shadow,
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
                            ? current.tick
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
                          color: current.shadow,
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
            bottom: 4,
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
                          child: Center(
                        child: Container(child:SicknessDialog(
                            items: current,
                            itemClick: this,
                            sicknessType: SicknessType.NORMAL,
                          ))));
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
                            ? current.tick
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
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }

  @override
  click() {
    setState(() {});
  }

  @override
  void dispose() {
    sicknessBloc.dispose();
    controller.dispose();
    super.dispose();
  }
}
