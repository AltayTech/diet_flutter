import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/const_&_model/list_data.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:behandam/const_&_model/slider_data.dart';

class PSYIntroScreen extends StatefulWidget {
  const PSYIntroScreen({Key? key}) : super(key: key);

  @override
  State<PSYIntroScreen> createState() => _PSYIntroScreenState();
}

class _PSYIntroScreenState extends ResourcefulState<PSYIntroScreen> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> setData() async{
    videoPlayerController = VideoPlayerController.network(
        'https://as6.cdn.asset.aparat.com/aparat-video/10f0d80a2216af1faab7e2fbbab14c3b16554542-480p.apt');
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {

    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.redBar,
          title: Text(intl.psy),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => VxNavigator.of(context).pop()),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 30.0),
                Center(
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Color(0xffE3EBEF)),
                    child: Center(
                        child: chewieController != null &&
                            chewieController!.videoPlayerController.value.isInitialized ?
                        Chewie(
                            controller:  chewieController!
                        ):
                        CircularProgressIndicator()
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h),
                        Text(intl.whoNeedPsySession,
                            style: TextStyle(fontSize: 14.sp)),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: GridView(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 100,
                                  childAspectRatio: 1/2,
                                  crossAxisSpacing: 50,
                                  mainAxisSpacing: 50
                              ),
                            children: List.generate(psySlider.length,(index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: AppColors.arcColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children:[
                                    Image.asset(psySlider[index].pic!,width: 90),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(psySlider[index].title!,
                                          style: TextStyle(fontSize: 12.sp)
                                        ),
                                        SizedBox(
                                          width: 120.0,
                                          child: Text(psySlider[index].desc!,
                                              style: TextStyle(fontSize: 10.sp)
                                          ),
                                        )
                                      ],
                                    ),
                                  ]
                              ),
                            )
                          ),
                        ),
                        ),
                        SizedBox(height: 3.h),
                      ]),
                  ),
                  ),
                SizedBox(height: 3.h),
               Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(5.0),
                     color: Colors.white
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(height: 3.h),
                     Text(intl.stepsOfPsy,
                         style: TextStyle(fontSize: 14.sp)),
                     SizedBox(height: 3.h),
                     Container(
                       height: 50.h,
                       child: ListView(
                         children :List.generate(psyList.length, (index) =>
                             Container(
                                 width: double.infinity,
                                 padding:
                                 EdgeInsets.symmetric(horizontal: 10),
                                 margin: EdgeInsets.only(left:20, right:20),
                                 child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: [
                                           Container(
                                             width: 10.w,
                                             height: 5.h,
                                             decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(5.0),
                                                 color: psyList[index].color!.withOpacity(0.5)),
                                             child: Center(
                                               child: Container(
                                                   width: 8.w,
                                                   height: 4.h,
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(5.0),
                                                       color: psyList[index].color),
                                                   child: SvgPicture.asset(psyList[index].pic!,
                                                     // width: 2.w,
                                                     // height: 2.h,
                                                     color: Colors.white,)),
                                             ),
                                           ),
                                           SizedBox(width: 3.w),
                                           Text(psyList[index].title!,style: TextStyle(fontSize: 14.sp),),
                                         ],
                                       ),
                                       index < 6
                                           ? Container(height: 5.h,width: 10.w, child: VerticalDivider(color: psyList[index].color!.withOpacity(0.5),thickness: 1.w,))
                                           :Container()
                                       // SizedBox(height: 10.0),
                                     ]))

                         ),
                       ),),
                     SizedBox(height: 3.h),
                   ],
                 ),
               ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if(chewieController!.isPlaying)
              chewieController!.pause();
            VxNavigator.of(context).push(Uri.parse(Routes.PSYCalender));
          },
          label: Container(
              width:50.w,
              height:10.h,
              child: Center(child: Text(intl.sessionReserve))),
          backgroundColor: AppColors.btnColor,
        ),
        floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
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
