import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/onboard/bloc.dart';
import 'package:behandam/screens/onboard/slider_introduces.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/data/entity/slider/slider.dart' as sliderModel;
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ResourcefulState<OnboardScreen> {
  late List<PageViewModel> pages = [];
  int _index = 0;
  List<sliderModel.Slider> slider = MemoryApp.sliders;
  List<sliderModel.SliderIntroduces> sliderIntroduces = MemoryApp.sliderIntroduces;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget showChampion() {
    return SingleChildScrollView(
      child: Container(
        height: 60.h,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                closeDialog(),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Center(
                        child: Text(
                          intl.kermanyChampions,
                          softWrap: false,
                          style: typography.caption!.copyWith(
                              fontFamily: 'yekan',
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.sp),
                        ),
                      ),
                    )),
              ],
            ),
            SliderIntroduces(introduces: sliderIntroduces)
          ],
        ),
      ),
    );
  }

  Widget closeDialog() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topRight,
        child: Container(
          decoration: AppDecorations.boxSmall
              .copyWith(color: Color(0x2531E6B0), border: Border.all(color: Color(0xaa104e40))),
          padding: EdgeInsets.all(1.w),
          child: Icon(
            Icons.close,
            size: 6.w,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // get data from splash for fast loading
    if (pages.isEmpty) fillPage(slider);

    return IntroductionScreen(
      pages: pages,
      onDone: () async {
        await AppSharedPreferences.setShowOnBoarding(false);
        VxNavigator.of(context).clearAndPush(Uri.parse(Routes.auth));
      },
      showBackButton: true,
      showSkipButton: false,
      next: CircleAvatar(
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
      ),
      back: CircleAvatar(
        child: Icon(
          Icons.arrow_forward,
          color: slider[_index].colorCode!.hexToColor,
        ),
        backgroundColor: Colors.white,
      ),
      done: CircleAvatar(
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
      ),
      rtl: true,
      onChange: (index) {
        setState(() {
          _index = index;
        });
      },
      dotsContainerDecorator: BoxDecoration(
        color: pages[_index].decoration.pageColor,
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.black.withOpacity(0.3),
        color: Colors.white,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }

  void fillPage(List<sliderModel.Slider> sliders) {
    sliders.forEach((slide) {
      pages.add(PageViewModel(
        title: slide.title!,
        body: slide.description!,
        footer: slide.priority == 2
            ? InkWell(
                onTap: () {
                  DialogUtils.showBottomSheetPageColor(
                      context: context, color: Color(0xff0E8562), child: showChampion());
                },
                child: ImageUtils.fromLocal(
                  "assets/images/onboarding/recorddar.png",
                  height: 10.h,
                  width: 60.w,
                ),
              )
            : Container(),
        image: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: ImageUtils.fromNetwork(
            slide.media?.originalUrl ?? '',
            height: 40.h,
            width: 70.w,
          ),
        )),
        decoration: PageDecoration(
            pageColor: slide.colorCode!.hexToColor,
            imageFlex: 0,
            bodyFlex: 1,
            bodyPadding: EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
            imagePadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            titleTextStyle: typography.headline5!.copyWith(
                color: Colors.white, fontFamily: 'yekan_bold', fontWeight: FontWeight.bold),
            bodyTextStyle: typography.caption!.copyWith(color: Colors.white, fontFamily: 'yekan')),
      ));
    });
  }
}
