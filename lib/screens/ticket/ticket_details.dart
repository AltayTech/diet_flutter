import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/detail_screen.dart';
import 'package:behandam/screens/widget/link_file.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:behandam/widget/custom_player.dart';
import 'package:behandam/widget/custom_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:velocity_x/velocity_x.dart';

class TicketDetails extends StatefulWidget {
  @override
  State createState() => _TicketDetailsState();
}

class _TicketDetailsState extends ResourcefulState<TicketDetails> {
  late TicketBloc bloc;
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = TicketBloc();
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
                              if (snapshot.data != null && snapshot.data == false) {
                                return ListView.builder(
                                    controller: _scrollController,
                                    itemCount: bloc.listTicketDetails.length,
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
                                                      bloc.listTicketDetails[index].createdAt!),
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
                                              // controller: _scrollController,
                                              itemCount:
                                                  bloc.listTicketDetails[index].messages!.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.only(bottom: 8, top: 8),
                                              physics: NeverScrollableScrollPhysics(),
                                              // ignore: missing_return
                                              itemBuilder: (context, i) {
                                                switch (bloc
                                                    .listTicketDetails[index].messages![i].type) {
                                                  case TypeTicketMessage.TEXT:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .listTicketDetails[index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () => {},
                                                          child: Container(
                                                            decoration: bloc
                                                                        .listTicketDetails[index]
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
                                                            child: Text(
                                                              bloc.listTicketDetails[index]
                                                                          .messages![i].body !=
                                                                      null
                                                                  ? bloc.listTicketDetails[index]
                                                                      .messages![i].body!
                                                                  : "",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                              textAlign: TextAlign.right,
                                                            ),
                                                            width: 70.w,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 70.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .listTicketDetails[index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style:
                                                                Theme.of(context).textTheme.caption,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  case TypeTicketMessage.TEXT_AND_ATTACHMENT:
                                                    if (Utils.checkFile(FlavorConfig
                                                                .instance.variables["baseUrlFile"] +
                                                            bloc.listTicketDetails[index]
                                                                .messages![i].file!.url) ==
                                                        TypeTicketItem.FILE) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: bloc
                                                                    .listTicketDetails[index]
                                                                    .messages![i]
                                                                    .isAdmin ==
                                                                0
                                                            ? CrossAxisAlignment.end
                                                            : CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            decoration: bloc
                                                                        .listTicketDetails[index]
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
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    ImageUtils.fromLocal(
                                                                      'assets/images/coach/pdf.svg',
                                                                      width: 6.w,
                                                                      height: 6.w,
                                                                    ),
                                                                    Expanded(
                                                                      child: new RichText(
                                                                        text: new LinkFile(
                                                                            style: Theme.of(context)
                                                                                .textTheme
                                                                                .caption,
                                                                            url: FlavorConfig
                                                                                        .instance
                                                                                        .variables[
                                                                                    "baseUrlFile"] +
                                                                                bloc
                                                                                    .listTicketDetails[
                                                                                        index]
                                                                                    .messages![i]
                                                                                    .file!
                                                                                    .url,
                                                                            text: bloc
                                                                                .listTicketDetails[
                                                                                    index]
                                                                                .messages![i]
                                                                                .file!
                                                                                .name),
                                                                      ),
                                                                      flex: 1,
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (bloc.listTicketDetails[index]
                                                                        .messages![i].body !=
                                                                    null)
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.only(top: 8),
                                                                    child: Container(
                                                                      width: double.maxFinite,
                                                                      child: Text(
                                                                        bloc
                                                                            .listTicketDetails[
                                                                                index]
                                                                            .messages![i]
                                                                            .body!,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .caption,
                                                                        textDirection: context
                                                                            .textDirectionOfLocale,
                                                                        textAlign: TextAlign.right,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                            width: 70.w,
                                                          ),
                                                          Container(
                                                            width: 70.w,
                                                            padding:
                                                                EdgeInsets.only(left: 8, right: 8),
                                                            child: Text(
                                                              DateTimeUtils.getTime(bloc
                                                                  .listTicketDetails[index]
                                                                  .messages![i]
                                                                  .createdAt!),
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else if (Utils.checkFile(FlavorConfig
                                                                .instance.variables["baseUrlFile"] +
                                                            bloc.listTicketDetails[index]
                                                                .messages![i].file!.url) ==
                                                        TypeTicketItem.IMAGE) {
                                                      return Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: bloc
                                                                    .listTicketDetails[index]
                                                                    .messages![i]
                                                                    .isAdmin ==
                                                                0
                                                            ? CrossAxisAlignment.end
                                                            : CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            decoration: bloc
                                                                        .listTicketDetails[index]
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
                                                            child: Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () => Navigator.push(
                                                                      context, MaterialPageRoute(
                                                                          builder: (_) {
                                                                    return DetailScreen(FlavorConfig
                                                                                .instance.variables[
                                                                            "baseUrlFile"] +
                                                                        bloc
                                                                            .listTicketDetails[
                                                                                index]
                                                                            .messages![i]
                                                                            .file!
                                                                            .url);
                                                                  })),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey[300],
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(16)),
                                                                    ),
                                                                    width: double.maxFinite,
                                                                    // child: cachedImage(FlavorConfig.instance
                                                                    //                 .variables[
                                                                    //             "baseUrlFile"] +
                                                                    //         items[index]
                                                                    //             .messages[i]
                                                                    //             .file!
                                                                    //             .url),
                                                                    child: ImageUtils.fromNetwork(
                                                                      FlavorConfig.instance
                                                                                  .variables[
                                                                              "baseUrlFile"] +
                                                                          bloc
                                                                              .listTicketDetails[
                                                                                  index]
                                                                              .messages![i]
                                                                              .file!
                                                                              .url,
                                                                      width: double.infinity,
                                                                      height: 0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (bloc.listTicketDetails[index]
                                                                        .messages![i].body !=
                                                                    null)
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.only(top: 8),
                                                                    child: Container(
                                                                      width: double.maxFinite,
                                                                      child: Text(
                                                                        bloc
                                                                            .listTicketDetails[
                                                                                index]
                                                                            .messages![i]
                                                                            .body!,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .caption,
                                                                        textDirection: context
                                                                            .textDirectionOfLocale,
                                                                        textAlign: TextAlign.right,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                            width: 70.w,
                                                          ),
                                                          Container(
                                                            width: 70.w,
                                                            padding:
                                                                EdgeInsets.only(left: 8, right: 8),
                                                            child: Text(
                                                              DateTimeUtils.getTime(bloc
                                                                  .listTicketDetails[index]
                                                                  .messages![i]
                                                                  .createdAt!),
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                    break;
                                                  case TypeTicketMessage.VOICE:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .listTicketDetails[index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: bloc.listTicketDetails[index]
                                                                      .messages![i].isAdmin ==
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
                                                            url: FlavorConfig.instance
                                                                    .variables["baseUrlFile"] +
                                                                bloc.listTicketDetails[index]
                                                                    .messages![i].file!.url,
                                                          ),
                                                          width: 70.w,
                                                        ),
                                                        Container(
                                                          width: 70.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .listTicketDetails[index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style:
                                                                Theme.of(context).textTheme.caption,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  case TypeTicketMessage.TEMP:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                              ...bloc.listTicketDetails[index]
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
                                                          width: 70.w,
                                                          padding:
                                                              EdgeInsets.only(left: 8, right: 8),
                                                          child: Text(
                                                            DateTimeUtils.getTime(bloc
                                                                .listTicketDetails[index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style:
                                                                Theme.of(context).textTheme.caption,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  default:
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: bloc
                                                                  .listTicketDetails[index]
                                                                  .messages![i]
                                                                  .isAdmin ==
                                                              0
                                                          ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          decoration: bloc.listTicketDetails[index]
                                                                      .messages![i].isAdmin ==
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
                                                              child: Image.asset(
                                                                'assets/images/logo.png',
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
                                                                .listTicketDetails[index]
                                                                .messages![i]
                                                                .createdAt!),
                                                            style:
                                                                Theme.of(context).textTheme.caption,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                }
                                              })
                                        ],
                                      );
                                    });
                              } else
                                return SpinKitCircle(
                                  size: 5.w,
                                  color: AppColors.primary,
                                );
                            },
                          ),
                        )),
                  ),
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
                    color: AppColors.colorselectDepartmentTicket,
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
                          : AppColors.colorselectDepartmentTicket,
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
                    support.isSelected ? AppColors.colorselectDepartmentTicket : Colors.grey[100],
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

  Widget templateItemWidget(TempItem templateItem) {
    if (templateItem.alterText != null) {
      return Html(
        data: "<div style='direction:rtl'> ${templateItem.alterText} </div>",
        shrinkWrap: true,
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
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }
}
