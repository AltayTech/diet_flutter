import 'package:behandam/screens/widget/link_file.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../base/resourceful_state.dart';
import '../../base/utils.dart';
import '../../data/entity/daily_message.dart';
import '../../data/entity/ticket/ticket_item.dart';
import '../../widget/custom_video.dart';
import '../widget/progress.dart';
import '../widget/template.dart';
import '../widget/toolbar.dart';
import 'daily_message_bloc.dart';

class DailyMessage extends StatefulWidget {
  const DailyMessage({Key? key}) : super(key: key);

  @override
  _DailyMessageState createState() => _DailyMessageState();
}

class _DailyMessageState extends ResourcefulState<DailyMessage> {
  late DailyMessageBloc dailyMessageBloc;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.dailyMessage),
      body: SingleChildScrollView(
        child: SafeArea(
            child: StreamBuilder(
                stream: dailyMessageBloc.messageTemplate,
                builder: (_, AsyncSnapshot<TempTicket> snapshot){
                  if(snapshot.hasData)
                    return
                      Padding(
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
                                  return MessageTemplate(templateItem: snapshot.data!.data, index: index);
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