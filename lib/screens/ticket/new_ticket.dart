import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/ticket/ticket_type_button.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class NewTicket extends StatefulWidget {
  @override
  State createState() => _NewTicketState();
}

class _NewTicketState extends ResourcefulState<NewTicket> {
  late TicketBloc bloc;
  TextEditingController ticketTitleController = TextEditingController();
  TextEditingController ticketDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = TicketBloc();
    bloc.getSupportList();
    ticketTitleController.text = bloc.sendTicketMessage.title ?? '';
    ticketDescController.text = bloc.sendTicketMessage.body ?? '';
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
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                        Space(height: 4.h),
                        Text(
                          intl.titleQuestionTicket,
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        Space(height: 2.h),
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
                                                for (SupportItem s in bloc.SupportItems)
                                                  s.selected = false;
                                                item.selected = true;
                                                bloc.sendTicketMessage.departmentId = item.id;
                                                bloc.setSupportItemSelected();
                                              }),
                                      selectSupport: () => () {
                                            for (SupportItem s in bloc.SupportItems)
                                              s.selected = false;
                                            item.selected = true;
                                            bloc.sendTicketMessage.departmentId = item.id;
                                            bloc.setSupportItemSelected();
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
                        Space(height: 2.h),
                        textInput(
                            height: 9.h,
                            label: intl.subject,
                            value: bloc.sendTicketMessage.title ?? '',
                            textController: ticketTitleController,
                            validation: (validation) {},
                            onChanged: (onChanged) {
                              bloc.sendTicketMessage.title = onChanged;
                            },
                            maxLine: true,
                            enable: true,
                            ctx: context,
                            textDirection: context.textDirectionOfLocale),
                        Space(height: 2.h),
                        Container(
                          height: 24.h,
                          child: Directionality(
                            textDirection: context.textDirectionOfLocale,
                            child: StreamBuilder(
                              builder: (context, AsyncSnapshot<bool> snapshot) {
                                return textInput(
                                    height: 6.h,
                                    label: intl.lableTextMessage,
                                    textController: ticketDescController,
                                    validation: (validation) {},
                                    onChanged: (onChanged) {
                                      bloc.sendTicketMessage.body = onChanged;
                                    },
                                    enable: !(snapshot.data ?? false),
                                    maxLine: true,
                                    ctx: context,
                                    textDirection: context.textDirectionOfLocale,
                                    icon: Icons.keyboard);
                              },
                              stream: bloc.isShowRecorder,
                            ),
                          ),
                        ),
                        TicketTypeButton(),
                        Space(height: 2.h),
                        StreamBuilder(
                            stream: bloc.isShowProgressItem,
                            builder: (context, snapshot) {
                              if (snapshot.data == null || snapshot.data == false)
                                return Padding(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    child: SubmitButton(
                                      onTap: checkTypeTicketForSend,
                                      label: intl.sendMessage,
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

  void checkTypeTicketForSend() {
    if (bloc.sendTicketMessage.title != null && bloc.sendTicketMessage.title!.length > 0) {
      if (bloc.sendTicketMessage.departmentId != null) {
        if (bloc.sendTicketMessage.body != null && bloc.sendTicketMessage.body!.length > 0) {
          bloc.sendTicketText();
        } else if (bloc.isFileAudio) {
          bloc.sendTicketFile();
        } else
          Utils.getSnackbarMessage(context, intl.errorBodyTicket);
      } else {
        Utils.getSnackbarMessage(context, intl.errorDepartment);
      }
    } else
      Utils.getSnackbarMessage(context, intl.errorTitleTicket);
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
              child: StreamBuilder(
                  stream: bloc.supportItemSelected,
                  builder: (context, snapshot) {
                    return CircleAvatar(
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
                    );
                  }),
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
              child: StreamBuilder(
                  stream: bloc.supportItemSelected,
                  builder: (context, snapshot) {
                    return Container(
                      color: support.isSelected
                          ? AppColors.colorSelectDepartmentTicket
                          : Colors.grey[100],
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
                    );
                  }),
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
    checkTypeTicketForSend();
  }

  @override
  void onRetryLoadingPage() {
    bloc.getSupportList();
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
