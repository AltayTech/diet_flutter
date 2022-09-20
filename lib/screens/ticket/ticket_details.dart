import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/user_information.dart' as info;
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/detail_screen.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/link_file.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:behandam/widget/custom_player.dart';
import 'package:behandam/widget/custom_video.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:open_file/open_file.dart';

class TicketDetails extends StatefulWidget {
  @override
  State createState() => _TicketDetailsState();
}

class _TicketDetailsState extends ResourcefulState<TicketDetails> {
  late TicketBloc bloc;

  final ScrollController _scrollController = new ScrollController();
  TextEditingController? controller;
  var args;

  String? inputMessage;
  bool isEnableButton = true;

  @override
  void initState() {
    super.initState();
    print('init');
    controller = TextEditingController();
    bloc = TicketBloc();
    bloc.showShowSendButton(false);
    //  bloc.getDetailTicket(args);
    listen();
  }

  void listen() {
    bloc.showServerError.listen((event) {
      if (event.toString().contains("error")) {
        Utils.getSnackbarMessage(context, intl.errorDescriptionTicket);
      } else {
        Utils.getSnackbarMessage(context, event);
      }
    });
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments;
      bloc.getDetailTicket(args);
    }
    //print('args = > $args');
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
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
              child: Column(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      transform: Matrix4.translationValues(0.0, -12.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: AppColors.background,
                      ),
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        child: StreamBuilder(
                          stream: bloc.progressNetwork,
                          builder: (ctx, snapshot) {
                            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
                            if (snapshot.data != null &&
                                snapshot.data == false &&
                                bloc.ticketDetails != null) {
                              return ScrollConfiguration(
                                behavior: MyCustomScrollBehavior(),
                                child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: bloc.ticketDetails!.items!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.only(bottom: 8, top: 12),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 0.7,
                                                ),
                                                flex: 1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 16, bottom: 8, top: 8),
                                                child: Text(
                                                  DateTimeUtils.gregorianToJalali(
                                                      bloc.ticketDetails!.items![index].createdAt!),
                                                  style: Theme.of(context).textTheme.caption,
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  height: 0.7,
                                                ),
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                          ListView.builder(
                                              itemCount: bloc
                                                  .ticketDetails!.items![index].messages!.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.only(bottom: 8, top: 8),
                                              physics: NeverScrollableScrollPhysics(),
                                              // ignore: missing_return
                                              itemBuilder: (context, i) {
                                                debugPrint(
                                                    'message => ${bloc.ticketDetails!.items![index].messages![i].toJson()}');
                                                switch (bloc.ticketDetails!.items![index]
                                                    .messages![i].type) {
                                                  case TypeTicketMessage.TEXT:
                                                    return Column(
                                                      textDirection: context.textDirectionOfLocale,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .ticketDetails!
                                                                  .items![index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.start
                                                          : CrossAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () => {},
                                                            child: Container(
                                                              decoration: bloc
                                                                          .ticketDetails!
                                                                          .items![index]
                                                                          .messages![i]
                                                                          .isAdmin ==
                                                                      0
                                                                  ? BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight:
                                                                              Radius.circular(16),
                                                                          topLeft:
                                                                              Radius.circular(16),
                                                                          bottomLeft:
                                                                              Radius.circular(16)))
                                                                  : BoxDecoration(
                                                                      color: Color(0x2655596E),
                                                                      borderRadius: BorderRadius.only(
                                                                          topRight:
                                                                              Radius.circular(16),
                                                                          topLeft:
                                                                              Radius.circular(16),
                                                                          bottomRight:
                                                                              Radius.circular(16))),
                                                              padding: EdgeInsets.all(16),
                                                              margin: EdgeInsets.only(
                                                                  right: 3.w, left: 3.w),
                                                              child: Text(
                                                                bloc.ticketDetails!.items![index]
                                                                            .messages![i].body !=
                                                                        null
                                                                    ? bloc
                                                                        .ticketDetails!
                                                                        .items![index]
                                                                        .messages![i]
                                                                        .body!
                                                                    : "",
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .caption,
                                                                textAlign: TextAlign.start,
                                                              ),
                                                              width: 70.w,
                                                            )),
                                                        Container(
                                                          width: 70.w,
                                                          padding: EdgeInsets.only(
                                                              left: 8, right: 8, top: 3),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .ticketDetails!
                                                                .items![index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .overline!
                                                                .copyWith(
                                                                    color: AppColors.labelColor),
                                                            textAlign: TextAlign.end,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  case TypeTicketMessage.TEXT_AND_ATTACHMENT:
                                                    return Align(
                                                      alignment: bloc.ticketDetails!.items![index]
                                                                  .messages![i].isAdmin ==
                                                              0
                                                          ? Alignment.centerRight
                                                          : Alignment.centerLeft,
                                                      child: Container(
                                                          margin: EdgeInsets.only(
                                                              right: 3.w, left: 3.w),
                                                          width: 70.w,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                decoration: bloc
                                                                            .ticketDetails!
                                                                            .items![index]
                                                                            .messages![i]
                                                                            .isAdmin ==
                                                                        0
                                                                    ? BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(16),
                                                                            topLeft:
                                                                                Radius.circular(16),
                                                                            bottomLeft:
                                                                                Radius.circular(
                                                                                    16)))
                                                                    : BoxDecoration(
                                                                        color: Color(0x2655596E),
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(16),
                                                                            topLeft:
                                                                                Radius.circular(16),
                                                                            bottomRight:
                                                                                Radius.circular(
                                                                                    16))),
                                                                padding: EdgeInsets.all(16),
                                                                child: Column(
                                                                    textDirection: context
                                                                        .textDirectionOfLocale,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                    crossAxisAlignment: bloc
                                                                                .ticketDetails!
                                                                                .items![index]
                                                                                .messages![i]
                                                                                .isAdmin ==
                                                                            0
                                                                        ? CrossAxisAlignment.end
                                                                        : CrossAxisAlignment.start,
                                                                    children: [
                                                                      ...bloc
                                                                          .ticketDetails!
                                                                          .items![index]
                                                                          .messages![i]
                                                                          .file!
                                                                          .asMap()
                                                                          .map((id, value) => MapEntry(
                                                                              id,
                                                                              itemFileWidget(
                                                                                  value,
                                                                                  bloc
                                                                                      .ticketDetails!
                                                                                      .items![index]
                                                                                      .messages![i])))
                                                                          .values
                                                                          .toList(),
                                                                      if (bloc
                                                                              .ticketDetails!
                                                                              .items![index]
                                                                              .messages![i]
                                                                              .body !=
                                                                          null)
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: 8),
                                                                          child: Container(
                                                                            width: double.maxFinite,
                                                                            child: Text(
                                                                              bloc
                                                                                  .ticketDetails!
                                                                                  .items![index]
                                                                                  .messages![i]
                                                                                  .body!,
                                                                              style:
                                                                                  Theme.of(context)
                                                                                      .textTheme
                                                                                      .caption,
                                                                              textDirection: context
                                                                                  .textDirectionOfLocale,
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ]),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.only(
                                                                    left: 8, right: 8),
                                                                child: Text(
                                                                  DateTimeUtils.getTime(bloc
                                                                      .ticketDetails!
                                                                      .items![index]
                                                                      .messages![i]
                                                                      .createdAt!),
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .overline!
                                                                      .copyWith(
                                                                          color:
                                                                              AppColors.labelColor),
                                                                  textAlign: bloc
                                                                              .ticketDetails!
                                                                              .items![index]
                                                                              .messages![i]
                                                                              .isAdmin ==
                                                                          1
                                                                      ? TextAlign.start
                                                                      : TextAlign.end,
                                                                ),
                                                                width: double.maxFinite,
                                                              ),
                                                            ],
                                                          )),
                                                    );
                                                  case TypeTicketMessage.VOICE:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .ticketDetails!
                                                                  .items![index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.start
                                                          : CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          decoration: bloc
                                                                      .ticketDetails!
                                                                      .items![index]
                                                                      .messages![i]
                                                                      .isAdmin ==
                                                                  0
                                                              ? BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(16),
                                                                      topLeft: Radius.circular(16),
                                                                      bottomLeft:
                                                                          Radius.circular(16)))
                                                              : BoxDecoration(
                                                                  color: Color(0x2655596E),
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(16),
                                                                      topLeft: Radius.circular(16),
                                                                      bottomRight:
                                                                          Radius.circular(16))),
                                                          padding: EdgeInsets.all(16),
                                                          child: CustomPlayer(
                                                            isAdmin: false,
                                                            media: Media.remoteExampleFile,
                                                            url: Utils.getCompletePath(bloc.ticketDetails!.items![index]
                                                                .messages![i].file![0].url),
                                                          ),
                                                          width: 70.w,
                                                        ),
                                                        Container(
                                                          width: 70.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .ticketDetails!
                                                                .items![index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .overline!
                                                                .copyWith(
                                                                    color: AppColors.labelColor),
                                                            textAlign: TextAlign.end,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  case TypeTicketMessage.TEMP:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(0x2655596E),
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius.circular(16),
                                                                  topLeft: Radius.circular(16),
                                                                  bottomRight:
                                                                      Radius.circular(16))),
                                                          padding: EdgeInsets.all(16),
                                                          child: Column(
                                                            children: [
                                                              ...bloc.ticketDetails!.items![index]
                                                                  .messages![i].temp!.data!
                                                                  .asMap()
                                                                  .map((index, value) => MapEntry(
                                                                      index,
                                                                      templateItemWidget(value)))
                                                                  .values
                                                                  .toList()
                                                            ],
                                                          ),
                                                          width: 80.w,
                                                        ),
                                                        Container(
                                                          width: 80.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .ticketDetails!
                                                                .items![index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .overline!
                                                                .copyWith(
                                                                    color: AppColors.labelColor),
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  default:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .ticketDetails!
                                                                  .items![index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: bloc
                                                                      .ticketDetails!
                                                                      .items![index]
                                                                      .messages![i]
                                                                      .isAdmin ==
                                                                  0
                                                              ? BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(16),
                                                                      topLeft: Radius.circular(16),
                                                                      bottomLeft:
                                                                          Radius.circular(16)))
                                                              : BoxDecoration(
                                                                  color: Color(0x2655596E),
                                                                  borderRadius: BorderRadius.only(
                                                                      topRight: Radius.circular(16),
                                                                      topLeft: Radius.circular(16),
                                                                      bottomRight:
                                                                          Radius.circular(16))),
                                                          padding: EdgeInsets.all(16),
                                                          child: GestureDetector(
                                                            onTap: () => Navigator.push(context,
                                                                MaterialPageRoute(builder: (_) {
                                                              return DetailScreen(
                                                                  'https://pngimg.com/uploads/mario/mario_PNG125.png');
                                                            })),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey[300],
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(16)),
                                                              ),
                                                              child: ImageUtils.fromLocal(
                                                                'assets/images/ticket/user_avatar.svg',
                                                                width: 25.w,
                                                                height: 25.w,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          width: 70.w,
                                                        ),
                                                        Container(
                                                          width: 70.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .ticketDetails!
                                                                .items![index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .overline!
                                                                .copyWith(
                                                                    color: AppColors.labelColor),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                }
                                              })
                                        ],
                                      );
                                    }),
                              );
                            } else
                              return SpinKitCircle(
                                size: 5.w,
                                color: AppColors.primary,
                              );
                          },
                        ),
                      )),
                ),
                StreamBuilder(
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
                ),
                StreamBuilder(
                  builder: (context, snapshot) {
                    switch (snapshot.data) {
                      case TypeTicket.MESSAGE:
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              )),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.data == null || snapshot.data == false) {
                                    return StreamBuilder(
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null && snapshot.data == true ||
                                            kIsWeb) {
                                          return GestureDetector(
                                            onTap: () {
                                              bloc.sendTicketTextDetail();
                                              controller!.value =
                                                  TextEditingController(text: '').value;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.all(2.w),
                                              child: ImageUtils.fromLocal(
                                                'assets/images/foodlist/share/send.svg',
                                                width: 6.w,
                                                height: 6.w,
                                                color: AppColors.surface,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              bloc.changeType(TypeTicket.RECORD);
                                              bloc.createRecord();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              padding: EdgeInsets.all(2.w),
                                              child: ImageUtils.fromLocal(
                                                'assets/images/ticket/recorder.svg',
                                                color: Colors.white,
                                                width: 6.w,
                                                height: 6.w,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      stream: bloc.isShowSendButton,
                                    );
                                  } else {
                                    return SpinKitCircle(
                                      color: AppColors.primary,
                                      size: 5.w,
                                    );
                                  }
                                },
                                stream: bloc.isShowProgressItem,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF2F2FB),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child:
                                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Expanded(
                                      child: Directionality(
                                        textDirection: context.textDirectionOfLocale,
                                        child: Padding(
                                          child: TextField(
                                            controller: controller,
                                            onChanged: (val) {
                                              if (val.isEmpty) {
                                                bloc.showShowSendButton(false);
                                              } else
                                                bloc.showShowSendButton(true);
                                              bloc.sendTicketMessage.body = val;
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'پیام خودت رو اینجا بنویس',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(color: AppColors.labelColor)),
                                          ),
                                          padding: EdgeInsets.only(right: 2.w, left: 2.w),
                                        ),
                                      ),
                                    ),
                                    if (!kIsWeb) SizedBox(width: 2.w),
                                    if (!kIsWeb)
                                      GestureDetector(
                                        onTap: () async {
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
                                                          style:
                                                              Theme.of(context).textTheme.caption,
                                                        )),
                                                  ],
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10, left: 10),
                                          child: ImageUtils.fromLocal(
                                            'assets/images/ticket/attach.svg',
                                            width: 6.w,
                                            height: 6.w,
                                            color: AppColors.labelColor,
                                          ),
                                        ),
                                      ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        );
                      case TypeTicket.RECORD:
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Row(children: [
                              StreamBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.data == null || snapshot.data == false) {
                                    return GestureDetector(
                                      onTap: () async {
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
                                    );
                                  } else {
                                    return StreamBuilder(
                                      builder: (context, snapshot) {
                                        if (snapshot.data == null || snapshot.data == false) {
                                          return GestureDetector(
                                            onTap: () {
                                              controller!.value =
                                                  TextEditingController(text: '').value;
                                              bloc.sendTicketFileDetail();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.all(2.w),
                                              child: ImageUtils.fromLocal(
                                                'assets/images/foodlist/share/send.svg',
                                                width: 6.w,
                                                height: 6.w,
                                                color: AppColors.surface,
                                              ),
                                            ),
                                          );
                                          ;
                                        } else {
                                          return SpinKitCircle(
                                            color: AppColors.primary,
                                            size: 5.w,
                                          );
                                        }
                                      },
                                      stream: bloc.isShowProgressItem,
                                    );
                                  }
                                },
                                stream: bloc.isShowFileAudio,
                              ),
                              Space(
                                width: 1.w,
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
                                        height: 8.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Color(0xffA7A9B4)),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 2.h, vertical: 0.5.h),
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
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              )),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                builder: (context, snapshot) {
                                  if (snapshot.data == null || snapshot.data == false) {
                                    return StreamBuilder(
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null && snapshot.data == true ||
                                            kIsWeb) {
                                          return GestureDetector(
                                            onTap: () {
                                              bloc.sendTicketTextDetail();
                                              controller!.value =
                                                  TextEditingController(text: '').value;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.all(2.w),
                                              child: ImageUtils.fromLocal(
                                                'assets/images/foodlist/share/send.svg',
                                                width: 6.w,
                                                height: 6.w,
                                                color: AppColors.surface,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              bloc.changeType(TypeTicket.RECORD);
                                              bloc.createRecord();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              padding: EdgeInsets.all(2.w),
                                              child: ImageUtils.fromLocal(
                                                'assets/images/ticket/recorder.svg',
                                                color: Colors.white,
                                                width: 6.w,
                                                height: 6.w,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      stream: bloc.isShowSendButton,
                                    );
                                  } else {
                                    return SpinKitCircle(
                                      color: AppColors.primary,
                                      size: 5.w,
                                    );
                                  }
                                },
                                stream: bloc.isShowProgressItem,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF2F2FB),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child:
                                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    Expanded(
                                      child: Directionality(
                                        textDirection: context.textDirectionOfLocale,
                                        child: Padding(
                                          child: TextField(
                                            controller: controller,
                                            onChanged: (val) {
                                              if (val.isEmpty) {
                                                bloc.showShowSendButton(false);
                                              } else
                                                bloc.showShowSendButton(true);
                                              bloc.sendTicketMessage.body = val;
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'پیام خودت رو اینجا بنویس',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(color: AppColors.labelColor)),
                                          ),
                                          padding: EdgeInsets.only(right: 2.w, left: 2.w),
                                        ),
                                      ),
                                    ),
                                    if (!kIsWeb) SizedBox(width: 2.w),
                                    if (!kIsWeb)
                                      GestureDetector(
                                        onTap: () async {
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
                                                          style:
                                                              Theme.of(context).textTheme.caption,
                                                        )),
                                                  ],
                                                ),
                                              ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10, left: 10),
                                          child: ImageUtils.fromLocal(
                                            'assets/images/ticket/attach.svg',
                                            width: 6.w,
                                            height: 6.w,
                                            color: AppColors.labelColor,
                                          ),
                                        ),
                                      ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        );
                      default:
                        return Container(
                          color: Colors.redAccent,
                        );
                    }
                  },
                  stream: bloc.typeTicket,
                )
              ]),
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

  Widget itemFileWidget(info.Media value, MessageTicket ticket) {
    return Column(
      textDirection: context.textDirectionOfLocale,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: ticket.isAdmin == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (value.mediumType == MediumType.file)
          Row(
            textDirection: context.textDirectionOfLocale,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: RichText(
                    text: new LinkFile(
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          decoration: TextDecoration.underline, color: Colors.lightBlueAccent),
                      url: Utils.getCompletePath(value.url) ,
                      text: '${value.fileName}',
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                flex: 1,
              ),
              /*ImageUtils.fromLocal(
                                'assets/images/ticket/pdf.svg',
                                width: 6.w,
                                height: 6.w,
                                color: AppColors.primary),*/
            ],
          ),
        if (value.mediumType == MediumType.IMAGE)
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(Utils.getCompletePath(value.url));
            })),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              width: double.maxFinite,
              child: ImageUtils.fromNetwork(
                FlavorConfig.instance.variables["baseUrlFile"] + value.url,
                width: double.infinity,
                height: 20.h,
              ),
            ),
          ),
        Space(
          height: 2.h,
        )
      ],
    );
  }

  Widget templateItemWidget(TempItem templateItem) {
    if (templateItem.alterText != null) {
      return Html(
        data: "<div style='direction:rtl'> ${templateItem.alterText} </div>",
        shrinkWrap: true,
        onLinkTap: (url, context, attributes, element) {
          Utils.launchURL(url!);
        },
      );
    } else {
      if (templateItem.media!.isNotEmpty && templateItem.media![0].mediumType == MediumType.file) {
        templateItem.media![0].progress = false;
        String? name = templateItem.media![0].fileName;
        if (Utils.checkExistFile(name, bloc.tempDir!.path)) {
          templateItem.media![0].mediumUrls!.url = "${bloc.tempDir!.path}/$name";
        }
      }
      MediumType? mediumType = templateItem.media![0].mediumType;
      switch (mediumType) {
        case MediumType.IMAGE:
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(templateItem.media![0].mediumUrls!.url);
            })),
            child: Container(
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  templateItem.media![0].mediumUrls!.url!,
                  fit: BoxFit.fill,
                  loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColors.accentColor,
                        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primary),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        case MediumType.VIDEO:
          return Container(
            margin: EdgeInsets.only(top: 1.h),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CustomVideo(
                image: null,
                isLooping: false,
                isStart: false,
                url: templateItem.media![0].mediumUrls!.url,
              ),
            ),
          );
        case MediumType.file:
          return Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: !templateItem.media![0].progress!
                        ? Icon(
                            (templateItem.media![0].mediumUrls!.url!
                                    .contains("${bloc.tempDir!.path}"))
                                ? Icons.file_present
                                : Icons.download_rounded,
                            color: Colors.white,
                          )
                        : SpinKitCircle(
                            size: 70.0,
                            itemBuilder: (BuildContext context, index) {
                              return DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 3,
                                      ),
                                      color: Colors.white,
                                      shape: BoxShape.circle));
                            },
                          ),
                  ),
                  onTap: () async {
                    if (!templateItem.media![0].mediumUrls!.url!
                        .contains("${bloc.tempDir!.path}")) {
                      setState(() {
                        templateItem.media![0].progress = true;
                      });
                      bloc.downloadFile(templateItem.media![0].fileName,
                          templateItem.media![0].mediumUrls!.url, templateItem.media![0]);
                    } else {
                      var f = await OpenFile.open(templateItem.media![0].mediumUrls!.url!);
                      if (f.type == ResultType.noAppToOpen || f.type == ResultType.error) {
                        Utils.getSnackbarMessage(context, "برنامه ای جهت بازکردن فایل پیدا نشد.");
                      } else if (f.type == ResultType.fileNotFound ||
                          f.type == ResultType.permissionDenied) {
                        Utils.getSnackbarMessage(context, "این فایل وجود ندارد.");
                      }
                    }
                  },
                ),
                Expanded(
                  child: Padding(
                    child: Text(
                        "${templateItem.media![0].name}.${templateItem.media![0].fileName!.split(".").last}"),
                    padding: EdgeInsets.only(left: 4),
                  ),
                )
              ],
            ),
          );
        case MediumType.AUDIO:
          return Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: CustomPlayer(
              isAdmin: false,
              media: Media.remoteExampleFile,
              url: templateItem.media![0].mediumUrls!.url,
            ),
          );
        default:
          return Container();
      }
    }
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    bloc.setRepository();
    switch (bloc.typeTicketValue) {
      case TypeTicket.MESSAGE:
        bloc.sendTicketTextDetail();
        break;
      case TypeTicket.RECORD:
        bloc.sendTicketFileDetail();
        break;
      case TypeTicket.IMAGE:
        bloc.sendTicketTextDetail();
        break;
    }
  }

  @override
  void onRetryLoadingPage() {
    bloc.setRepository();
    bloc.getDetailTicket(args);
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
