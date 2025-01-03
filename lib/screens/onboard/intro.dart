import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/slider/slider.dart' as sliderModel;
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/onboard/slider_introduces.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
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
        height: 500,
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
            SliderIntroduces(introduces: MemoryApp.sliderIntroduces)
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
    if (pages.isEmpty) fillPage();
    // get data from splash for fast loading

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
          color: pages[_index].decoration.pageColor,
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

  void fillPage() {
    MemoryApp.sliderIntroduces.add(sliderModel.SliderIntroduces()
      ..media = 'assets/images/onboarding/r1.png'
      ..fullName = 'سمیرا حاجیزاده'
      ..description = '21 کیلوگرم کاهش وزن'
      ..old_weight = 73.0
      ..new_weight = 52.0);
    MemoryApp.sliderIntroduces.add(sliderModel.SliderIntroduces()
      ..media = 'assets/images/onboarding/r2.png'
      ..fullName = 'سهیل آدینه'
      ..description = '43 کیلوگرم کاهش وزن'
      ..old_weight = 132.0
      ..new_weight = 89.0);
    MemoryApp.sliderIntroduces.add(sliderModel.SliderIntroduces()
      ..media = 'assets/images/onboarding/r3.png'
      ..fullName = 'گیتا محترمی'
      ..description = '30 کیلوگرم کاهش وزن'
      ..old_weight = 105.0
      ..new_weight = 75.0);

    pages.add(PageViewModel(
      body:
          "برنامه غذایی دکتر کرمانی بر اساس شرایط جسمانی خود شما تنظیم و همه شرایط شما در نظر گرفته میشه. حواسمون به عادت‌های غذایی شما هست!",
      image: Center(
          child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: ImageUtils.fromLocal(
          "assets/images/onboarding/1.png",
          height: 40.h,
          width: 70.w,
        ),
      )),
      titleWidget: ImageUtils.fromLocal("assets/images/onboarding/t1.svg",
          height: 10.h, width: 70.w, padding: EdgeInsets.only(top: 0, left: 10.w, right: 10.w)),
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
    pages.add(PageViewModel(
      titleWidget: ImageUtils.fromLocal("assets/images/onboarding/t2.svg",
          height: 15.h, width: 40.w, padding: EdgeInsets.only(left: 25.w, right: 25.w)),
      body:
          "با رعایت برنامه غذایی دکتر کرمانی و کمک پشتیبان‌های ما میتونی توی 3 ماه، 12 کیلو کاهش وزن داشته باشی. قهرمانای زیادی از پسش براومدن، پس تو میتونی...",
      image: Center(
          child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: ImageUtils.fromLocal(
          "assets/images/onboarding/2.png",
          height: 35.h,
          width: 70.w,
        ),
      )),
      footer: InkWell(
        onTap: () {
          DialogUtils.showBottomSheetPageColor(
              context: context, color: Color(0xff0E8562), child: showChampion());
        },
        child: ImageUtils.fromLocal(
          "assets/images/onboarding/recorddar.png",
          height: 10.h,
          width: 60.w,
        ),
      ),
      decoration: PageDecoration(
          pageColor: Color(0xff33AD89),
          imageFlex: 0,
          bodyFlex: 1,
          bodyPadding: EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
          imagePadding: EdgeInsets.only(top: 16),
          titlePadding: EdgeInsets.zero,
          titleTextStyle: typography.headline5!
              .copyWith(color: Colors.white, fontFamily: 'yekan', fontWeight: FontWeight.bold),
          bodyTextStyle: typography.caption!.copyWith(color: Colors.white, fontFamily: 'yekan')),
    ));
    pages.add(PageViewModel(
      titleWidget: ImageUtils.fromLocal("assets/images/onboarding/t3.svg",
          height: 15.h, width: 50.w, padding: EdgeInsets.only(left: 20.w, right: 20.w)),
      body:
          "می‌تونین غذاهایی که دوست ندارین یا بهشون حساسیت دارین رو از برنامه رژیمتون حذف کنین و یا وعده پیشنهادی در برنامه‌تون رو با غذایی که در منزل دارین عوض کنین.",
      image: Center(
          child: Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: ImageUtils.fromLocal("assets/images/onboarding/3.png",
            height: 30.h,
            width: 70.w,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0)),
      )),
      decoration: PageDecoration(
          pageColor: Color(0xffFF5757),
          imageFlex: 0,
          bodyFlex: 1,
          bodyPadding: EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
          imagePadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          titleTextStyle: typography.headline5!
              .copyWith(color: Colors.white, fontFamily: 'yekan', fontWeight: FontWeight.bold),
          bodyTextStyle: typography.caption!.copyWith(color: Colors.white, fontFamily: 'yekan')),
    ));
  }

/* void fillPage(List<sliderModel.Slider> sliders) {
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
  }*/
}
