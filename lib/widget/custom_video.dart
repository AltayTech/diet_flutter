import 'dart:async';

import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Function(ChewieController chewieController)? callBackListener;

  CustomVideo(
      {Key? key,
      this.click,
      this.image,
      this.title,
      this.url,
      this.isLooping,
      this.isStart,
      this.onCompletion,
      this.callBackListener})
      : super(key: key);

  @override
  MyWidgetPlayer createState() => MyWidgetPlayer(click, image, title, url, isLooping);
}

class MyWidgetPlayer extends State<CustomVideo> implements ClickItem {
  Function? click;
  String? title;
  String? image;
  String? url;
  bool? isLooping;

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
  MyWidgetPlayer(this.click, this.image, this.title, this.url, this.isLooping) {
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
      return Stack(
        children: [
          Center(
            child: chewieController!.isPlaying
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: ClipRRect(
                        // transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                        borderRadius: BorderRadius.circular(10),
                        child: Chewie(
                          key: new PageStorageKey(url!),
                          controller: chewieController!,
                        )))
                : Stack(
                    children: [
                      (image != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageUtils.fromNetwork(
                                image!,
                              ),
                              // child: Image.network(
                              //   image!,
                              //   // height: SizeConfig.blockSizeVertical * 25,
                              //   width: double.infinity,
                              //   fit: BoxFit.fitWidth,
                              // ),
                            )
                          : Container(
                              color: Colors.white,
                            ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primary,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  if (widget.callBackListener != null)
                                    widget.callBackListener!(chewieController!);
                                  chewieController!.play();
                                }),
                                child: Container(
                                  width: 13.w,
                                  height: 13.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(4.w),
                                  child: SvgPicture.asset(
                                    'assets/images/gym/play_btn.svg',
                                    width: 7.w,
                                    height: 7.w,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              title != null
                                  ? Text(
                                      title!,
                                      textAlign: TextAlign.center,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      );
    } else
      return Center(
        child: SpinKitCircle(
          color: AppColors.primary,
          size: 5.w,
        ),
      );
  }

  @override
  void Click() {}
}
