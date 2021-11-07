import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  }

  @override
  void dispose() {
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
                        StreamBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.data != null && snapshot.data == false) {
                              return  Wrap(
                                spacing: 3.w,
                                runSpacing: 1.h,
                                textDirection: context.textDirectionOfLocale,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.start,
                                children: [
                                  ...bloc.SupportItems.map((item) => itemWithTick(
                                      child: illItem(
                                          support: item,
                                          showPastMeal: () => setState(() {
                                            bloc.selectedSupportId = item.id;
                                          })),
                                      selectSupport: () {},
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
                        Text(
                          intl.titleQuestionTicket,
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        textInput(
                            height: 6.h,
                            label: 'موضوع',
                            validation: (validation) {},
                            onChanged: (onChanged) {},
                            maxLine: true,
                            ctx: context,
                            textDirection: context.textDirectionOfLocale),
                        SizedBox(height: 2.h),
                        Container(
                            height: 24.h,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: textInput(
                                  height: 6.h,
                                  label: 'متن خود را اینجا وارد کنید',
                                  validation: (validation) {},
                                  onChanged: (onChanged) {},
                                  maxLine: true,
                                  ctx: context,
                                  textDirection: context.textDirectionOfLocale),
                            )),
                        StreamBuilder(
                          builder: (context, AsyncSnapshot<TypeTicket> snapshot) {
                            switch (snapshot.data) {
                              case TypeTicket.MESSAGE:
                                if (!kIsWeb)
                                  return Column(
                                    children: [
                                      Container(
                                          width: 80.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                topLeft: Radius.circular(16),
                                              )),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                //setState(() => createRecord());
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.all(Radius.circular(20)),
                                                ),
                                                padding: EdgeInsets.all(2.w),
                                                child: ImageUtils.fromLocal(
                                                  'assets/images/ticket/recorder.svg',
                                                  height: 6.w,
                                                  width: 6.w,
                                                ),
                                              ),
                                            ),
                                          )),
                                      Center(
                                        child: Text(
                                          'پیام صوتی',
                                          style: Theme.of(context).textTheme.caption,
                                        ),
                                      )
                                    ],
                                  );
                                return Container();
                              case TypeTicket.RECORD:
                                return Container(
                                  color: Colors.blue,
                                );
                              case TypeTicket.IMAGE:
                                return Container(
                                  color: Colors.green,
                                );
                              default:
                                return Container(
                                  color: Colors.redAccent,
                                );
                            }
                          },
                          stream: bloc.typeTicket,
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'ارسال پیام',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ))

                        /* if (Utils.isShowImage || isRecord || showRecordFile)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: (Utils.isShowImage)
                            ? Row(
                                children: [
                                  Text(
                                    // '44KB',
                                    '${DialogCustom.image!.lengthSync() ~/ 1024} KB',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      // 'dkjsfdksjkdjfkdsjfjkdsjflds.jpg',
                                      DialogCustom.image != null
                                          ? DialogCustom.image!.path.split('/').last
                                          : '',
                                      textAlign: TextAlign.start,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: Color(0xffA7A9B4),
                                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.blockSizeHorizontal * 11,
                                    height: SizeConfig.blockSizeVertical * 5.3,
                                    margin: EdgeInsets.only(left: 8),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: SizeConfig.blockSizeHorizontal * 6,
                                      ),
                                      onPressed: () async {
                                        await File(DialogCustom.image!.path).delete();
                                        setState(() {
                                          Utils.isShowImage = false;
                                          minute = 0;
                                          start = 0;
                                        });
                                      },
                                    ),
                                    decoration: BoxDecoration(
                                      color: CustomColors.tabSelected,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  )
                                ],
                              )
                            : isRecord
                                ? (showRecordFile)
                                    ? Container(
                                        height: SizeConfig.blockSizeVertical * 10,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Color(0xffA7A9B4)),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.blockSizeHorizontal * 2,
                                            vertical: SizeConfig.blockSizeVertical * 0.5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomPlayer(
                                                url: outputFile?.path,
                                                isAdmin: false,
                                                media: Media.file,
                                                timeRecord:
                                                    '${intl.NumberFormat('00').format(minute)}:${intl.NumberFormat('00').format(start)}',
                                              ),
                                            ),
                                            SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: CustomColors.tabSelected,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              width: SizeConfig.blockSizeHorizontal * 10,
                                              height: SizeConfig.blockSizeVertical * 5,
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                iconSize: SizeConfig.blockSizeHorizontal * 6,
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  _timer?.cancel();
                                                  if (outputFile != null &&
                                                      await outputFile!.exists())
                                                    await outputFile!.delete();
                                                  setState(() {
                                                    showRecordFile = false;
                                                    isRecord = true;
                                                    minute = 0;
                                                    start = 0;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                stopRecorder(false);
                                                _timer?.cancel();
                                                if (outputFile != null &&
                                                    await outputFile!.exists())
                                                  await outputFile!.delete();
                                                setState(() {
                                                  isRecord = false;
                                                  isRecording = false;
                                                  showRecordFile = false;
                                                  minute = 0;
                                                  start = 0;
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig.blockSizeHorizontal * 2),
                                                child: SvgPicture.asset(
                                                  'assets/images/coach/keyboard.svg',
                                                  width: SizeConfig.blockSizeHorizontal * 6,
                                                  height: SizeConfig.blockSizeHorizontal * 6,
                                                  color: CustomColors.tabSelected,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: FlatButton.icon(
                                                      onPressed: () async {
                                                        // Fimber.d('isrecording $isRecording');
                                                        if (isRecording) {
                                                          setState(() {
                                                            isRecording = false;
                                                            //showRecord = true;
                                                          });
                                                          if (_timer != null) _timer!.cancel();
                                                          stopRecorder(true);
                                                        } else {
                                                          record();
                                                        }
                                                      },
                                                      icon: CircleAvatar(
                                                        radius: SizeConfig.blockSizeHorizontal * 5,
                                                        backgroundColor: CustomColors.tabSelected,
                                                        child: kIsWeb
                                                            ? Image.network(
                                                                "assets/images/coach/microphone.svg",
                                                                height:
                                                                    SizeConfig.blockSizeHorizontal *
                                                                        6,
                                                                width:
                                                                    SizeConfig.blockSizeHorizontal *
                                                                        6,
                                                                color: Colors.white,
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/images/coach/microphone.svg',
                                                                width:
                                                                    SizeConfig.blockSizeHorizontal *
                                                                        6,
                                                                height:
                                                                    SizeConfig.blockSizeHorizontal *
                                                                        6,
                                                                color: Colors.white),
                                                      ),
                                                      label: Text(
                                                        isRecording ? 'پایان ضبط' : 'شروع ضبط',
                                                        style: TextStyle(
                                                          fontSize:
                                                              SizeConfig.blockSizeHorizontal * 3.5,
                                                          color: Colors.grey[700],
                                                        ),
                                                      )),
                                                ),
                                                if (isRecording)
                                                  Text(
                                                    '${intl.NumberFormat('00').format(minute)}:${intl.NumberFormat('00').format(start)}',
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                                                    ),
                                                  ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      )
                                : Container(),
                      ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: CustomButton(
                        click: () => {isEnableButton ? Send() : () {}},
                        txtColor: Colors.white,
                        bgColor: CustomColors.tabSelected,
                        splashColor: CustomColors.buttonClick,
                        title: Multilanguage.get("sendMessage"),
                      ),
                    ),*/
                        /* SizedBox(height: 2.h),*/
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
                    color: Color.fromRGBO(242, 233, 238, 1),
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
              // onTap: selectSupport,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(242, 233, 238, 1),
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
              //onTap: selectSupport,
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
                      color: support.id == bloc.selectedSupportId
                          ? Theme.of(context).primaryColorLight
                          : Color.fromRGBO(210, 210, 210, 1),
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
      //onTap: showPastMeal,
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
                color: support.id == bloc.selectedSupportId
                    ? Color.fromRGBO(243, 255, 249, 1)
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
}
