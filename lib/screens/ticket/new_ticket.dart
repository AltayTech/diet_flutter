import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/ticket/ticket_type_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTicket extends StatefulWidget {
  @override
  State createState() => _NewTicketState();
}

class _NewTicketState extends ResourcefulState<NewTicket> {
  late TicketBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = TicketBloc();
    bloc.getSupportList();
    listen();
  }

  void listen() {
    bloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
      VxNavigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TicketProvider(bloc,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: Toolbar(titleBar: intl.ticket),
            backgroundColor: AppColors.surface,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 4.h),
                        Text(
                          intl.titleQuestionTicket,
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        StreamBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.data != null && snapshot.data == false) {
                              return Wrap(
                                spacing: 3.w,
                                runSpacing: 1.h,
                                textDirection: context.textDirectionOfLocale,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  ...bloc.SupportItems.map((item) => itemWithTick(
                                      child: illItem(
                                          support: item,
                                          showPastMeal: () => () {
                                                setState(() {
                                                  for (SupportItem s in bloc.SupportItems)
                                                    s.selected = false;
                                                  item.selected = true;
                                                  bloc.sendTicketMessage.departmentId = item.id;
                                                });
                                              }),
                                      selectSupport: () => () {
                                            setState(() {
                                              for (SupportItem s in bloc.SupportItems)
                                                s.selected = false;
                                              item.selected = true;
                                              bloc.sendTicketMessage.departmentId = item.id;
                                            });
                                          },
                                      support: item)).toList()
                                ],
                              );
                            } else {
                              return Center(
                                child: SpinKitCircle(
                                  size: 5.h,
                                  color: AppColors.primary,
                                ),
                              );
                            }
                          },
                          stream: bloc.progressNetwork,
                        ),
                        SizedBox(height: 2.h),
                        textInput(
                            height: 8.h,
                            label: intl.subject,
                            value: bloc.sendTicketMessage.title ?? '',
                            validation: (validation) {},
                            onChanged: (onChanged) {
                              bloc.sendTicketMessage.title = onChanged;
                            },
                            maxLine: true,
                            enable: true,
                            ctx: context,
                            textDirection: context.textDirectionOfLocale),
                        SizedBox(height: 2.h),
                        Container(
                          height: 24.h,
                          child: Directionality(
                            textDirection: context.textDirectionOfLocale,
                            child: StreamBuilder(
                              builder: (context, AsyncSnapshot<bool> snapshot) {
                                return textInput(
                                    height: 6.h,
                                    label: intl.lableTextMessage,
                                    value: bloc.sendTicketMessage.body,
                                    validation: (validation) {},
                                    onChanged: (onChanged) {
                                      bloc.sendTicketMessage.body = onChanged;
                                    },
                                    enable: !(snapshot.data ?? false),
                                    maxLine: true,
                                    ctx: context,
                                    textDirection: context.textDirectionOfLocale);
                              },
                              stream: bloc.isShowRecorder,
                            ),
                          ),
                        ),
                        TicketTypeButton(),
                        SizedBox(height: 2.h),
                        StreamBuilder(
                            stream: bloc.isShowProgressItem,
                            builder: (context, snapshot) {
                              if (snapshot.data == null || snapshot.data == false)
                                return Padding(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    child: MaterialButton(
                                      onPressed: () {
                                        print('onChanged = > ${bloc.isFile}');
                                        if (bloc.isFile == true) {
                                          bloc.sendTicketFile();
                                        } else if (bloc.sendTicketMessage.title != null &&
                                            bloc.sendTicketMessage.title!.length > 0 &&
                                            bloc.sendTicketMessage.body != null &&
                                            bloc.sendTicketMessage.body!.length > 0) {
                                          if (bloc.sendTicketMessage.departmentId != null) {
                                            bloc.sendTicketText();
                                          } else {
                                            Utils.getSnackbarMessage(context, intl.errorDepartment);
                                          }
                                        } else
                                          Utils.getSnackbarMessage(context, intl.errorFillItem);
                                      },
                                      child: Text(
                                        'ارسال پیام',
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ));
                              else {
                                return Center(
                                  child: SpinKitCircle(
                                    size: 5.h,
                                    color: AppColors.primary,
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ),
        ));
  }

  Widget itemWithTick(
      {required Widget child, required SupportItem support, required Function selectSupport}) {
    return Container(
      height: 10.h,
      width: 25.w,
      child: Stack(
        children: <Widget>[
          // Container(child: child),
          Positioned(
            bottom: 4,
            right: 10,
            left: 10,
            child: Container(
              width: 10.w,
              height: 8.h,
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.colorSelectDepartmentTicket,
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            bottom: 20,
            right: 0,
            left: 0,
            child: GestureDetector(
              onTap: selectSupport(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 3.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 3,
            left: 3,
            child: GestureDetector(
              onTap: selectSupport(),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 4.w,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1.w),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ImageUtils.fromLocal(
                      'assets/images/bill/tick.svg',
                      width: 4.w,
                      height: 4.w,
                      color: support.isSelected
                          ? AppColors.primaryVariantLight
                          : AppColors.colorSelectDepartmentTicket,
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

  Widget illItem({required SupportItem support, required Function showPastMeal}) {
    return GestureDetector(
      onTap: showPastMeal(),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color:
                    support.isSelected ? AppColors.colorSelectDepartmentTicket : Colors.grey[100],
                width: double.infinity,
                height: double.infinity,
                child: ClipPath(
                  clipper: BottomTriangle(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 3.w,
                ),
                child: Text(
                  support.ticketName != null && support.ticketName!.length > 0
                      ? support.ticketName!
                      : support.displayName != null && support.displayName!.length > 0
                          ? support.displayName!
                          : support.name!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
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
}
