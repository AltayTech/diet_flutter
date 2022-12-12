import 'package:behandam/base/repository.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

class WidgetIconTextProgress extends StatefulWidget {
  late bool countShow;
  late String title;
  late String listIcon;
  late int index;

  WidgetIconTextProgress(
      {required this.countShow, required this.title, required this.listIcon, required this.index});

  @override
  State createState() => WidgetIconTextProgressState();
}

class WidgetIconTextProgressState extends ResourcefulState<WidgetIconTextProgress> {
  late ProfileBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = ProfileProvider.of(context);
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        switch (widget.index) {
          case 0:
            launchURL('http://support.kermany.com/');
            break;
          case 1:
            //Navigator.of(context).pushNamed(InboxList.routeName);
            break;
          case 2:
            DialogUtils.showDialogPage(
                context: context,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    width: double.maxFinite,
                    decoration: AppDecorations.boxLarge.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          intl.receiveList,
                          style: TextStyle(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                          textDirection: context.textDirectionOfLocale,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          intl.pdfTxt,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: AppColors.penColor),
                          textDirection: context.textDirectionOfLocale,
                        ),
                        SizedBox(height: 3.h),
                        SubmitButton(
                            label: intl.receiveTermPdf,
                            onTap: () {
                              Navigator.pop(context);
                              bloc.getPdfMeal(FoodDietPdf.TERM);
                            }),
                        SizedBox(height: 1.h),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(70.w, 5.h)),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text(intl.cancelPdf,
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(color: AppColors.btnColor)),
                        ),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                ));
            break;
          case 3:
            VxNavigator.of(context).push(Uri.parse(Routes.refund));
        }
      },
      child: Row(
        textDirection: context.textDirectionOfLocale,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ImageUtils.fromLocal(
            widget.listIcon,
            width: 9.w,
            height: 9.w,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color.fromARGB(255, 114, 114, 114),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 6.h,
                  height: 6.h,
                  child: StreamBuilder(
                    stream: bloc.isShowProgressItem,
                    builder: (context, snapshot) {
                      return (snapshot.data == true && widget.index == 2)
                          ? SpinKitCircle(
                              size: 4.w,
                              color: AppColors.primary,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                textDirection: context.textDirectionOfLocale,
                                color: Color.fromARGB(255, 171, 170, 170),
                              ),
                              iconSize: 4.w,
                              padding: EdgeInsets.all(0.0),
                              alignment: Alignment.centerLeft,
                              onPressed: () {},
                            );
                    },
                  )),
            ],
          ),
          SizedBox(width: 2.w),
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
