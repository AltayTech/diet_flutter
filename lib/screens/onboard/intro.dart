import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/onboard/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/data/entity/slider/slider.dart' as sliderModel;
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ResourcefulState<OnboardScreen> {
  late List<PageViewModel> pages = [];
  int _index = 0;
  late List<Color> pageColor = [
    Color(0xff321E6C),
    Color(0xff0E8562),
    Color(0xffD02B2B),
    Color(0xff0E8562),
    Color(0xff321E6C),
  ];

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
        padding: EdgeInsets.all(5.w),
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
                          'قهرمانان دکتر کرمانی',
                          softWrap: false,
                          style: typography.caption!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp),
                        ),
                      ),
                    )),
              ],
            ),
            Expanded(
              child: ImageUtils.fromLocal(
                "assets/images/onboarding/r2.png",
                height: 40.h,
                width: 100.w,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.white24,
                  size: 35,
                ),
                ImageUtils.fromLocal(
                  "assets/images/onboarding/cup.png",
                  height: 10.h,
                  width: 20.w,
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سمیرا حاجیزاده',
                          textAlign: TextAlign.start,
                          softWrap: false,
                          style: typography.caption!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '21 کیلوگرم کاهش وزن',
                          softWrap: false,
                          textAlign: TextAlign.start,
                          style: typography.caption!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                Icon(Icons.chevron_right_outlined, color: Colors.white24, size: 35),
              ],
            )
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

    if (pages.isEmpty) fillPage(MemoryApp.sliders);

    return IntroductionScreen(
          pages: pages,
          onDone: () async {
            await AppSharedPreferences.setShowOnBoarding(true);
            VxNavigator.of(context).clearAndPush(Uri.parse(Routes.auth));
          },
          showBackButton: true,
          showSkipButton: false,
          next: CircleAvatar(
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            backgroundColor: pageColor[_index],
          ),
          back: CircleAvatar(
            child: Icon(
              Icons.arrow_forward,
              color: pageColor[_index],
            ),
            backgroundColor: Colors.white,
          ),
          done: CircleAvatar(
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            backgroundColor: pageColor[_index],
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
            activeColor: pageColor[_index],
            color: Colors.white,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          ),
        );
  }

  void fillPage(List<sliderModel.Slider> sliders) {
    sliders.forEach((slide) {
      pages.add(PageViewModel(
        body: slide.description!,
        image: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: ImageUtils.fromNetwork(
            slide.media?.originalUrl ?? '',
            height: 40.h,
            width: 70.w,
          ),
        )),
        titleWidget: Text(slide.title!),
        decoration: PageDecoration(
            pageColor: Color(0xff5342C3),
            imageFlex: 0,
            bodyFlex: 1,
            bodyPadding: EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
            imagePadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            titleTextStyle: typography.headline5!
                .copyWith(color: Colors.white, fontFamily: 'yekan', fontWeight: FontWeight.bold),
            bodyTextStyle: typography.caption!.copyWith(color: Colors.white, fontFamily: 'yekan')),
      ));
    });
  }
}
