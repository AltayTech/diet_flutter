import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_player.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class TicketTypeButton extends StatefulWidget {
  TicketTypeButton();

  @override
  State createState() => TicketTypeButtonState();
}

class TicketTypeButtonState extends ResourcefulState<TicketTypeButton> {
  late TicketBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = TicketProvider.of(context);
    return body();
  }

  Widget body() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot<TypeTicket> snapshot) {
        switch (snapshot.data) {
          case TypeTicket.MESSAGE:
            if (!kIsWeb)
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 30.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          )),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                bloc.sendTicketMessage.body = null;
                                bloc.changeType(TypeTicket.RECORD);
                                bloc.createRecord();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                padding: EdgeInsets.all(2.w),
                                child: ImageUtils.fromLocal(
                                  'assets/images/ticket/recorder.svg',
                                  height: 6.w,
                                  width: 6.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Center(
                        child: Text(
                          intl.soundMessage,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 30.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          )),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                DialogUtils.showBottomSheetPage(
                                    context: context,
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        color: AppColors.surface,
                                      ),
                                      child: Column(
                                        children: [
                                          Space(
                                            height: 2.h,
                                          ),
                                          Text(
                                            intl.pickImage,
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                          Space(
                                            height: 2.h,
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              bloc.selectGallery();
                                            },
                                            minWidth: 80.w,
                                            height: 7.h,
                                            child: Text(
                                              intl.selectGallery,
                                              style: Theme.of(context).textTheme.caption,
                                            ),
                                          ),
                                          Line(
                                            width: 80.w,
                                            height: 0.1.h,
                                            color: AppColors.labelColor,
                                          ),
                                          MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                bloc.selectCamera();
                                              },
                                              minWidth: 80.w,
                                              height: 7.h,
                                              child: Text(
                                                intl.selectCamera,
                                                style: Theme.of(context).textTheme.caption,
                                              )),
                                        ],
                                      ),
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                padding: EdgeInsets.all(2.w),
                                child: ImageUtils.fromLocal(
                                  'assets/images/ticket/attach.svg',
                                  height: 6.w,
                                  width: 6.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Center(
                        child: Text(
                          intl.selectedFile,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      )
                    ],
                  )
                ],
              );
            return Container();
          case TypeTicket.RECORD:
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Row(children: [
                  GestureDetector(
                    onTap: () async {
                      bloc.sendTicketMessage.body = null;
                      bloc.changeType(TypeTicket.MESSAGE);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: ImageUtils.fromLocal(
                        'assets/images/ticket/keyboard.svg',
                        width: 6.w,
                        height: 6.w,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data == null || snapshot.data == false) {
                        return Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: bloc.showTime,
                                builder: (context, AsyncSnapshot<String> snapshot) {
                                  if ((snapshot.data != null || snapshot.data == true))
                                    return Text(
                                      snapshot.data ?? '',
                                      style: Theme.of(context).textTheme.caption,
                                    );
                                  else {
                                    return Container();
                                  }
                                },
                              ),
                              Directionality(
                                textDirection: context.textDirectionOfLocale,
                                child: TextButton.icon(
                                    onPressed: () {
                                      bloc.record();
                                      //print('recording = > ${bloc.isRecording}');
                                    },
                                    icon: CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: AppColors.primary,
                                      child: kIsWeb
                                          ? Image.network(
                                              "assets/images/coach/recorder.svg",
                                              height: 6.w,
                                              width: 6.w,
                                              color: Colors.white,
                                            )
                                          : ImageUtils.fromLocal(
                                              'assets/images/ticket/recorder.svg',
                                              width: 6.w,
                                              height: 6.w,
                                              color: Colors.white),
                                    ),
                                    label: StreamBuilder(
                                      stream: bloc.isRecording,
                                      builder: (context, snapshot) {
                                        return Text(
                                          (!snapshot.hasData || snapshot.data == true)
                                              ? intl.endRecord
                                              : intl.startRecord,
                                          style: Theme.of(context).textTheme.caption,
                                        );
                                      },
                                    )),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffA7A9B4)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 0.5.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomPlayer(
                                    url: bloc.outputFile?.path,
                                    isAdmin: false,
                                    media: Media.file,
                                    timeRecord: '${bloc.showTimeRecord}',
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 10.w,
                                  height: 5.h,
                                  child: IconButton(
                                    alignment: Alignment.center,
                                    iconSize: 6.w,
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      bloc.stopAndStart();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          flex: 1,
                        );
                      }
                    },
                    stream: bloc.isShowFileAudio,
                  )
                ]));
          case TypeTicket.IMAGE:
            return StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data == true) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          )),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        textDirection: context.textDirectionOfLocale,
                        children: [
                          Text(
                            '${bloc.imageFile!.lengthSync() ~/ 1024} KB',
                            style: Theme.of(context).textTheme.overline,
                            textDirection: context.textDirectionOfLocaleInversed,
                          ),
                          Expanded(
                            child: Padding(
                              child: Text(
                                bloc.image!.path.split('/').last,
                                textAlign: TextAlign.start,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                textDirection: context.textDirectionOfLocale,
                                style: Theme.of(context).textTheme.overline,
                              ),
                              padding: EdgeInsets.only(left: 3.w, right: 3.w),
                            ),
                          ),
                          Container(
                            width: 11.w,
                            height: 5.3.h,
                            margin: EdgeInsets.only(left: 8),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 6.w,
                              ),
                              onPressed: () async {
                                bloc.stopAndStart();
                                bloc.changeType(TypeTicket.MESSAGE);
                              },
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )
                        ],
                      ));
                } else {
                  return Container();
                }
              },
              stream: bloc.isShowImage,
            );
          default:
            return Container(
              color: Colors.redAccent,
            );
        }
      },
      stream: bloc.typeTicket,
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
