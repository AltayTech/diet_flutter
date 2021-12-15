import 'dart:async';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/screens/refund/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/utils/card_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class RefundRecordScreen extends StatefulWidget {
  RefundRecordScreen({Key? key}) : super(key: key);

  @override
  State<RefundRecordScreen> createState() => _RefundRecordScreenState();
}

class _RefundRecordScreenState extends ResourcefulState<RefundRecordScreen> {
  late RefundBloc bloc;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    bloc = RefundBloc();
    bloc.getTermPackage();
    _textEditingController.text = bloc.cardOwner ?? '';
    blocListener();
  }

  void blocListener() {
    bloc.navigateTo.listen((event) {
      Utils.getSnackbarMessage(context, intl.successRequest);
      Timer(Duration(milliseconds: 1500), () {
        VxNavigator.of(context).popToRoot();
      });
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
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 245, 245, 245),
          width: 100.w,
          padding: EdgeInsets.only(
            left: 4.w,
            right: 3.w,
            top: 3.h,
            bottom: 6.h,
          ),
          child: Column(
            textDirection: context.textDirectionOfLocale,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Space(height: 2.h),
                          Image.asset(
                            'assets/images/diet/refund.png',
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.cover,
                          ),
                          Space(height: 2.h),
                          Text(intl.pleaseFillInformation,
                              style: Theme.of(context).textTheme.caption),
                          Space(height: 4.h),
                          Container(
                            width: double.infinity,
                            child: Text(intl.cardNumberFull,
                                textDirection: context.textDirectionOfLocale,
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Space(height: 1.h),
                          Container(
                              height: 9.h,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextFormField(
                                  initialValue: bloc.cardNumber ?? null,
                                  decoration: inputDecoration.copyWith(
                                    labelText: '',
                                    hintText: intl.cardNumber,
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(color: Colors.black38),
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .overline!
                                        .copyWith(color: Colors.black38),
                                  ),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    new LengthLimitingTextInputFormatter(16),
                                    new CardNumberInputFormatter()
                                  ],
                                  keyboardType: TextInputType.phone,
                                  onChanged: (val) {
                                    setState(() => bloc.cardNumber = val.replaceAll(' - ', ''));
                                  },
                                  onSaved: (val) => bloc.cardNumber = val,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.black87),
                                ),
                              )),
                          Space(height: 2.h),
                          Container(
                            width: double.infinity,
                            child: Text(intl.cardNumberOwner,
                                textDirection: context.textDirectionOfLocale,
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Space(height: 1.h),
                          textInput(
                            value: bloc.cardOwner ?? '',
                            label: intl.accountOwnerName,
                            onChanged: (val) {
                              // _textEditingController.text = val;
                              // _textEditingController.selection = TextSelection.fromPosition(
                              //     TextPosition(offset: _textEditingController.text.length));
                              bloc.cardOwner = val;
                            },
                            maxLine: false,
                            textInputType: TextInputType.text,
                            ctx: context,
                            enable: true,
                            height: 8.h,
                            textDirection: context.textDirectionOfLocale,
                            textController: _textEditingController,
                            validation: (value) {},
                          ),
                          Space(height: 2.h),
                          SubmitButton(
                            label: intl.confirmContinue,
                            onTap: () {
                              if (bloc.cardNumber != null && bloc.cardNumber!.length > 15) {
                                if (bloc.cardOwner != null && bloc.cardOwner!.isNotEmpty) {
                                  DialogUtils.showDialogProgress(context: context);
                                  bloc.record();
                                } else
                                  Utils.getSnackbarMessage(context, intl.pleaseFillAllParams);
                              } else {
                                Utils.getSnackbarMessage(
                                  context,
                                  intl.validationCardNumber,
                                );
                              }
                            },
                          ),
                          Space(height: 2.h),
                          Container(
                              height: 6.5.h,
                              width: 55.w,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  intl.cancel,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  textDirection: context.textDirectionOfLocale,
                                  style: Theme.of(context).textTheme.caption!,
                                ),
                              )),
                          Space(height: 3.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
