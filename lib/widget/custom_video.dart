import 'dart:async';
import 'dart:io';

import 'package:behandam/app/app.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/fake_ui.dart'
    if (dart.library.html) 'package:behandam/utils/real_ui.dart' as ui;
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import "package:universal_html/html.dart" as html;
import 'package:video_player/video_player.dart';

abstract class CallBackListener {
  void notifyChange();
}

class CustomVideo extends StatefulWidget {
  Function? click;
  String? title;
  String? image;
  String? url;
  bool? isLooping;
  bool? isStart;
  Function? onCompletion;
  bool? isFile;
  Function(ChewieController chewieController)? callBackListener;
  String? src;
  final double startAt = 0;
  final bool autoplay = false;
  final bool controls = true;

  CustomVideo(
      {Key? key,
      this.click,
      this.image,
      this.title,
      this.url,
      this.isLooping,
      this.isStart,
      this.onCompletion,
      this.isFile,
      this.callBackListener,
      this.src})
      : super(key: key);

  @override
  MyWidgetPlayer createState() => MyWidgetPlayer(click, image, title, url, isLooping, isFile);
}

class MyWidgetPlayer extends State<CustomVideo> {
  Function? click;
  String? title;
  String? image;
  String? url;
  bool? isLooping;
  bool? isFile;

  late VideoPlayerController _controller;
  double? aspect;
  var playerWidget;
  bool logEvent = false;
  ChewieController? chewieController;
  bool _initializeVideoPlayerFuture = false, showBottomSheet = true;

  MyWidgetPlayer(this.click, this.image, this.title, this.url, this.isLooping, this.isFile) {
    if (isLooping == null) this.isLooping = false;
  }

  @override
  void initState() {
    super.initState();
    kIsWeb ? webPlayer() : setData();
  }

  void webPlayer() {
    widget.src = widget.url;
    String? URL = widget.src! + '#t=${widget.startAt}';
    // Do not remove the below comment - Fix for missing ui.platformViewRegistry in dart.ui
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(widget.src!, (int viewId) {
      final video = html.VideoElement()
        ..src = URL
        ..autoplay = widget.autoplay
        ..controls = widget.controls
        ..style.border = 'none'
        ..style.borderColor = 'red'
        ..style.height = '100%'
        ..style.width = '100%';

      // Allows Safari iOS to play the video inline
      video.setAttribute('playsinline', 'true');

      return video;
    });
  }

  void setData() async {
    try {
      if (url == null) {
        _controller = VideoPlayerController.asset('assets/video.mp4');
      } else if (isFile != null) {
        _controller = VideoPlayerController.file(File(url!));
      } else
        _controller = VideoPlayerController.network(url!);
      await Future.wait([_controller.initialize()]);

      _controller.addListener(() {
        if (widget.onCompletion != null && _controller.value.isInitialized) {
          if (_controller.value.duration == _controller.value.position && showBottomSheet) {
            widget.onCompletion!();
            showBottomSheet = false;
          }
          setState(() => {});
        }
        if (_controller.value.isPlaying && !logEvent) {
          logEvent = true;
          try {
            MemoryApp.analytics!.logEvent(
                name: "play_video",
                parameters: {'page': '${navigator.currentConfiguration!.path}'});
          } catch (e) {}
        } else if (!_controller.value.isPlaying && logEvent) {
          logEvent = false;
          try {
            MemoryApp.analytics!.logEvent(
                name: "stop_video",
                parameters: {'page': '${navigator.currentConfiguration!.path}'});
          } catch (e) {}
        }
      });

      chewieController = ChewieController(
        videoPlayerController: _controller,
        allowMuting: false,
        allowedScreenSleep: false,
        autoPlay: false,
        allowPlaybackSpeedChanging: false,
        looping: this.isLooping!,
        showControlsOnInitialize: true,
      );

      if (widget.callBackListener != null) widget.callBackListener!.call(chewieController!);

      if (chewieController != null && chewieController!.videoPlayerController.value.isInitialized) {
        setState(() {
          _initializeVideoPlayerFuture = true;
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }

//Color(0xff62D0C5)
  @override
  Widget build(BuildContext context) {
    if (kIsWeb)
      return HtmlElementView(viewType: widget.src!);
    else if (_initializeVideoPlayerFuture) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      // transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                      borderRadius: BorderRadius.circular(10),
                      child: Chewie(
                        key: new PageStorageKey(url!),
                        controller: chewieController!,
                      ))),
            ),
          ],
        ),
      );
    } else
      return Center(
        child: SpinKitCircle(
          color: AppColors.primary,
          size: 7.w,
        ),
      );
  }
}
