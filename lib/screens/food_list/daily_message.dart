import 'package:behandam/screens/widget/link_file.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../base/resourceful_state.dart';
import '../../base/utils.dart';
import '../../data/entity/daily_message.dart';
import '../../widget/custom_video.dart';
import '../widget/progress.dart';
import '../widget/toolbar.dart';
import 'daily_message_bloc.dart';

class DailyMessage extends StatefulWidget {
  const DailyMessage({Key? key}) : super(key: key);

  @override
  _DailyMessageState createState() => _DailyMessageState();
}

class _DailyMessageState extends ResourcefulState<DailyMessage> {
  late DailyMessageBloc dailyMessageBloc;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  final ScrollController controller = ScrollController();

  @override
  initState(){
    super.initState();
    dailyMessageBloc = DailyMessageBloc();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as int;
    dailyMessageBloc.getDailyMessage(args);
  }

  VideoController(ChewieController chewieController) async{
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.dailyMessage),
      body: SingleChildScrollView(
        controller: controller,
        child: SafeArea(
            child: StreamBuilder(
                stream: dailyMessageBloc.messageTemplate,
                builder: (_, AsyncSnapshot<DailyMessageTemplate> snapshot){
                  if(snapshot.hasData)
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.title!),
                          SizedBox(height: 2.h),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, index) {
                                if(snapshot.data!.data![index].media!.length == 0)
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data!.data![index].alterText!.substring(3,snapshot.data!.data![index].alterText!.length - 4)),
                                        SizedBox(height: 4.h),
                                      ],
                                    ),
                                  );
                                else if(snapshot.data!.data![index].media![0].mediumUrls!.url!.contains(".mp4"))
                                  return Column(
                                    children: [
                                      // Text(snapshot.data!.data![index].media![0].name!),
                                      Container(
                                          width: 330,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                              color: Color(0xffE3EBEF)),
                                          child:
                                          Center(child: CustomVideo(
                                              url: snapshot.data!.data![index].media![0].mediumUrls!.url,
                                              isStart: false,
                                              callBackListener: VideoController))
                                      ),
                                      SizedBox(height: 4.h),
                                    ],
                                  );
                                else if(snapshot.data!.data![index].media![0].mediumUrls!.url!.contains(".mp3"))
                                  return Column(
                                    children: [
                                      // Text(snapshot.data!.data![index].media![0].name!),
                                      CustomPlayer(
                                        isAdmin: false,
                                        media: Media.remoteExampleFile,
                                        url: snapshot.data!.data![index].media![0].mediumUrls!.url,
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  );
                                else if(snapshot.data!.data![index].media![0].mediumUrls!.url!.contains(".jpg"))
                                  return Column(
                                    children: [
                                      // Text(snapshot.data!.data![index].media![0].name!),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                                        child: Image.network(snapshot.data!.data![index].media![0].mediumUrls!.url!),
                                      ),
                                      SizedBox(height: 4.h),
                                    ],
                                  );
                                else
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ImageUtils.fromLocal('assets/images/google-docs.png',width: 25.0, height: 25.0),
                                          ),
                                          RichText(
                                            text: new LinkFile(
                                                style: TextStyle(fontSize: 18, color: Colors.black),
                                                text: snapshot.data!.data![index].media![0].name,
                                                url: snapshot.data!.data![index].media![0].mediumUrls!.url!)),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                    ],
                                  );
                              }
                          ),
                        ],
                      ),
                    );
                  else
                    return Utils.loading(30.0);
                }
            )
        ),
      )
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