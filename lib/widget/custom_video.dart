import 'dart:async';
import 'dart:io';

import 'package:behandam/themes/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

abstract class CallBackListener {
  void notifyChange();
}

abstract class ClickItem {
  void Click();
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
  Function(ChewieController chewieController) ? callBackListener;

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
      this.callBackListener})
      : super(key: key);

  @override
  MyWidgetPlayer createState() => MyWidgetPlayer(click, image, title, url, isLooping, isFile);
}

class MyWidgetPlayer extends State<CustomVideo> implements ClickItem {
  Function? click;
  String? title;
  String? image;
  String? url;
  bool? isLooping;
  bool? isFile;

  // Duration? _position;
  // Duration? _duration;
  // bool _isPlaying = false;
  // bool _isEnd = false;
  late VideoPlayerController _controller;
  double? aspect;
  var playerWidget;
  ChewieController? chewieController;
  bool _initializeVideoPlayerFuture = false, showBottomSheet = true;

  //double width;
  // double height;
  MyWidgetPlayer(this.click, this.image, this.title, this.url, this.isLooping, this.isFile) {
    if (isLooping == null) this.isLooping = false;
  }

  @override
  void initState() {
    super.initState();

    // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

    setData();
    /*  _controller.addL
istener(() {

        Timer.run(() {
          this.setState((){
            _position = _controller.value.position;
          });
        });
        setState(() {
          _duration = _controller.value.duration;
        });
        _duration?.compareTo(_position) == 0 || _duration?.compareTo(_position) == -1 ? this.setState((){
          _isEnd = true;
        }) : this.setState((){
          _isEnd = false;
        });

        if(_isEnd){
          _controller.seekTo(new Duration(milliseconds: 0));
        }
      });*/

    /*_controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            // aspect= _controller.value.aspectRatio;
            Fimber.d("aspect Ratio =>$aspect");
            _controller.setLooping(false);
          });
        });*/
    // }
  }

  Future<void> setData() async {
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
      if (chewieController != null && chewieController!.videoPlayerController.value.isInitialized) {
        setState(() {
          _initializeVideoPlayerFuture = true;
          //chewieController!.togglePause();
        });
      }
/*      if(chewieController != null && chewieController!.videoPlayerController.value.isInitialized)
        _initializeVideoPlayerFuture = Future.delayed(Duration(seconds: 1));*/

    } catch (e) {
      //Fimber.d("error video ${e.toString()}");
    }
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
    if (_initializeVideoPlayerFuture) {
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

  @override
  void Click() {}
}
