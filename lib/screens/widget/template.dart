import 'dart:io';

import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../base/utils.dart';
import '../../data/entity/ticket/ticket_item.dart';
import '../../themes/colors.dart';
import '../../utils/image.dart';
import '../../widget/custom_player.dart';
import '../../widget/custom_video.dart';
import 'detail_screen.dart';

class MessageTemplate extends StatefulWidget {
  List<TempItem>? templateItem;
  int? index;

  MessageTemplate({this.templateItem, this.index});

  @override
  _MessageTemplateState createState() => _MessageTemplateState();
}

class _MessageTemplateState extends State<MessageTemplate> {
  late Directory tempDir;
  late Future<Directory?> path;
  late int _test;

  @override
  initState() {
    super.initState();
    path = getPath();
  }

  Future<Directory?> getPath() async {
    tempDir = await getTemporaryDirectory();
    debugPrint("path:$tempDir");
    return tempDir;
  }

  Widget templateWidget(List<TempItem>? templateItem, int index) {
    if (templateItem![index].media!.length == 0) {
      return Html(
        data: "<div style='direction:rtl'> ${templateItem[index].alterText} </div>",
        shrinkWrap: true,
        onLinkTap: (url, context, attributes, element) {
          Utils.launchURL(url!);
        },
      );
    } else {
      MediumType? mediumType = templateItem[index].media![0].mediumType;
      if (templateItem[index].media!.isNotEmpty &&
          templateItem[index].media![0].mediumType == MediumType.file &&
          !templateItem[index].media![0].mediumUrls!.url!.contains("${tempDir.path}")) {
        if (templateItem[index].media![0].progress == null)
          templateItem[index].media![0].progress = false;
        String? name = templateItem[index].media![0].fileName;
        if (Utils.checkExistFile(name, tempDir.path)) {
          templateItem[index].media![0].mediumUrls!.url = "${tempDir.absolute.path}/$name";
        }
      }
      switch (mediumType) {
        case MediumType.IMAGE:
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(templateItem[index].media![0].mediumUrls!.url);
            })),
            child: Container(
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ImageUtils.fromNetwork(
                  templateItem[index].media![0].mediumUrls!.url!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        case MediumType.VIDEO:
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 1.h),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CustomVideo(
                    image: null,
                    isLooping: false,
                    isStart: false,
                    url: templateItem[index].media![0].mediumUrls!.url,
                  ),
                ),
              ),
              SizedBox(height: 2.h)
            ],
          );
        case MediumType.file:
          return Column(
            children: [
              Container(
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
                        child: !templateItem[index].media![0].progress!
                            ? Icon(
                                (templateItem[index]
                                        .media![0]
                                        .mediumUrls!
                                        .url!
                                        .contains("${tempDir.path}"))
                                    ? Icons.file_present
                                    : Icons.download_rounded,
                                color: Colors.white,
                              )
                            : SpinKitCircle(
                                size: 5.w,
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
                        if (!templateItem[index]
                            .media![0]
                            .mediumUrls!
                            .url!
                            .contains("${tempDir.path}")) {
                          setState(() => templateItem[index].media![0].progress = true);
                          downloadFile(templateItem[index]);
                        } else {
                          var f =
                              await OpenFile.open(templateItem[index].media![0].mediumUrls!.url!);
                          if (f.type == ResultType.noAppToOpen || f.type == ResultType.error) {
                            Utils.getSnackbarMessage(
                                context, "برنامه ای جهت بازکردن فایل پیدا نشد.");
                          } else if (f.type == ResultType.fileNotFound ||
                              f.type == ResultType.permissionDenied) {
                            Utils.getSnackbarMessage(context, "این فایل وجود ندارد.");
                          }
                        }
                      },
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Padding(
                        child: Text(
                            "${templateItem[index].media![0].name}.${templateItem[index].media![0].fileName!.split(".").last}"),
                        padding: EdgeInsets.only(left: 4),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 2.h)
            ],
          );
        case MediumType.AUDIO:
          return Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: CustomPlayer(
                  isAdmin: false,
                  media: Media.remoteExampleFile,
                  url: templateItem[index].media![0].mediumUrls!.url,
                ),
              ),
              SizedBox(height: 2.h)
            ],
          );
        default:
          return Container();
      }
    }
  }

  void downloadFile(TempItem item) async {
    Dio dio = Dio();
    try {
      var data = await dio
          .download(
              '${item.media![0].mediumUrls!.url}', '${tempDir.path}/${item.media![0].fileName}')
          .whenComplete(() {
        item.media![0].progress = false;
      });
      if (data.statusCode == 200)
        item.media![0].mediumUrls!.url = "${tempDir.path}/$item.media![0].fileName}";
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _test = widget.index!;
    return Container(
      child: FutureBuilder(
          future: path,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return templateWidget(widget.templateItem, widget.index!);
            else
              return EmptyBox();
          }),
    );
  }
}
