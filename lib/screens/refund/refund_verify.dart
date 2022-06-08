import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/refund/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RefundVerifyScreen extends StatefulWidget {
  RefundVerifyScreen({Key? key}) : super(key: key);

  @override
  State<RefundVerifyScreen> createState() => _RefundVerifyScreenState();
}

class _RefundVerifyScreenState extends ResourcefulState<RefundVerifyScreen> {
  late RefundBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = RefundBloc();
    bloc.getTermPackage();
    blocListener();
  }

  void blocListener() {
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).popToRoot();
      VxNavigator.of(context).push(Uri.parse(Routes.refundRecord));
    });
    bloc.serverError.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      appBar: Toolbar(
        titleBar: intl.refund,
      ),
      body: StreamBuilder(
          stream: null,
          builder: (context, snapshot) {
            bloc.setDate(DateTimeUtils.gregorianToJalali(DateTime.parse(
                    MemoryApp.termPackage!.term!.startedAt
                        .replaceAll(RegExp('-'), ''))
                .add(Duration(
                    days: MemoryApp.termPackage?.package!.refundDeadline ?? 0))
                .toString()));
            bloc.setCanRefund(MemoryApp.termPackage!.canRefund ?? false);
            if (MemoryApp.refundItem == null ||
                MemoryApp.refundItem!.items!.isEmpty) {
              if (bloc.canRefundValue) {
                bloc.message = intl.descriptionRefund(bloc.date);
              }
            } else {
              bloc.message = MemoryApp.refundItem!.items![0].refundStatus!.text;
            }
            return SingleChildScrollView(
              child: Container(
                color: Color.fromARGB(255, 245, 245, 245),
                width: 100.w,
                height: 80.h,
                padding: EdgeInsets.only(
                  left: 4.w,
                  right: 3.w,
                  top: 3.h,
                  bottom: 6.h,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                'assets/images/diet/refund.png',
                                width: 40.w,
                                height: 40.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            RichText(
                                textDirection: context.textDirectionOfLocale,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          '${MemoryApp.userInformation?.firstName ?? intl.user} ${intl.babe}',
                                      // text: 'کاربر عزیز',
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  TextSpan(
                                      text: intl.dietDiscontent,
                                      style:
                                          Theme.of(context).textTheme.caption),
                                  TextSpan(
                                      text: bloc.date,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: Colors.redAccent)),
                                  TextSpan(
                                      text: intl.requestRefundPaymentLabel,
                                      style:
                                          Theme.of(context).textTheme.caption)
                                ])),
                            SizedBox(height: 5.h),
                            StreamBuilder<bool>(
                                stream: bloc.showPass,
                                builder: (context, showPassword) {
                                  if (showPassword.hasData)
                                    return Container(
                                        height: 9.h,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: TextFormField(
                                            initialValue: bloc.password,
                                            decoration:
                                                inputDecoration.copyWith(
                                              labelText: intl.password,
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color:
                                                          AppColors.labelColor),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  if (showPassword
                                                      .requireData) {
                                                    bloc.setShowPassword(false);
                                                  } else {
                                                    bloc.setShowPassword(true);
                                                  }
                                                },
                                                icon: showPassword.requireData
                                                    ? Icon(Icons.visibility)
                                                    : Icon(
                                                        Icons.visibility_off),
                                                color: Color.fromARGB(
                                                    255, 205, 202, 202),
                                                iconSize: 20.0,
                                              ),
                                            ),
                                            obscureText:
                                                !showPassword.requireData,
                                            keyboardType: TextInputType.text,
                                            onChanged: (val) {
                                              setState(
                                                  () => bloc.password = val);
                                            },
                                            onSaved: (val) =>
                                                bloc.password = val,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 160, 158, 158),
                                              fontSize: 16.0,
                                            ),
                                            validator: (val) => val!.length < 4
                                                ? intl.validationPass
                                                : null,
                                          ),
                                        ));
                                  else
                                    return EmptyBox();
                                }),
                            SizedBox(height: 2.h),
                            SubmitButton(
                              onTap: () {
                                if (bloc.password != null &&
                                    bloc.password!.length > 3) {
                                  DialogUtils.showDialogProgress(
                                      context: context);
                                  bloc.verify();
                                } else {
                                  Utils.getSnackbarMessage(
                                      context, intl.minimumPasswordLength);
                                }
                              },
                              label: intl.acceptRefundPayment,
                            ),
                            SizedBox(height: 2.h),
                            Container(
                                height: 6.5.h,
                                width: 55.w,
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    intl.back,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    textDirection:
                                        context.textDirectionOfLocale,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(color: Colors.black54),
                                  ),
                                )),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    ));
  }

  @override
  void onRetryAfterNoInternet() {
    DialogUtils.showDialogProgress(context: context);
    bloc.verify();
  }

  @override
  void onRetryLoadingPage() {
    bloc.getTermPackage();
  }
}
