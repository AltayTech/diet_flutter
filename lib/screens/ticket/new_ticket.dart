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
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
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
            backgroundColor: AppColors.newBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    decoration: BoxDecoration(
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
                                spacing: 2.w,
                                runSpacing: 1.h,
                                textDirection: context.textDirectionOfLocale,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  ...bloc.SupportItems.map((item) => supportTypeItem(item)).toList()
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
                            bgColor: Colors.white,
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
                                    bgColor: Colors.white,
                                    onChanged: (onChanged) {
                                      bloc.sendTicketMessage.body = onChanged;
                                    },
                                    enable: !(snapshot.data ?? false),
                                    maxLine: true,
                                    ctx: context,
                                    textDirection: context.textDirectionOfLocale,
                                );
                              },
                              stream: bloc.isShowRecorder,
                            ),
                          ),
                        ),
                        TicketTypeButton(),
                        Space(height: 3.h),
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

  Widget supportTypeItem(SupportItem supportItem) {
    return StreamBuilder<bool>(
        stream: bloc.supportItemSelected,
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              for (SupportItem s in bloc.SupportItems) s.selected = false;
              supportItem.selected = true;
              bloc.sendTicketMessage.departmentId = supportItem.id;
              bloc.setSupportItemSelected();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: supportItem.isSelected ? Border.all(color: AppColors.primary) : null,
                borderRadius: AppBorderRadius.borderRadiusExtraLarge,
              ),
              constraints: BoxConstraints(minHeight: 6.h, maxWidth: 43.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  supportItem.isSelected
                      ? ImageUtils.fromString(
                          """<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="8.99976" cy="9" r="9" fill="#1ABC9C" />
                  <path
                  d="M12.848 4.17668C12.9324 4.15083 13.0318 4.17265 13.0956 4.23481C13.5696 4.70928 14.0439 5.18328 14.5181 5.65752C14.6137 5.74861 14.6168 5.9199 14.5212 6.01195C11.9344 8.59783 9.34897 11.1849 6.7619 13.7705C6.65799 13.8683 6.47698 13.8472 6.39157 13.735C5.33611 12.6785 4.27993 11.6226 3.22375 10.5667C3.12838 10.4744 3.13171 10.304 3.2266 10.2127C3.70178 9.73799 4.1765 9.26304 4.65121 8.78809C4.74325 8.69937 4.90363 8.69889 4.99662 8.78691C5.47299 9.26233 5.94865 9.73894 6.42479 10.2148C6.51494 10.3043 6.67412 10.3045 6.76475 10.2155C8.73002 8.25028 10.6953 6.28477 12.6606 4.31974C12.717 4.26541 12.7678 4.19614 12.848 4.17668Z"
                  fill="white" />
                  </svg>
                      """
                              .replaceAll('#1ABC9C', "#ff5757"),
                          width: 3.w,
                          height: 3.h,
                        )
                      : ImageUtils.fromLocal(
                          "assets/images/bill/not_select.svg",
                          width: 3.w,
                          height: 3.h,
                        ),
                  Space(
                    width: 2.w,
                  ),
                  Text(
                    supportItem.displayName ?? "",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: typography.caption,
                  ),
                ],
              ),
            ),
          );
        });
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
