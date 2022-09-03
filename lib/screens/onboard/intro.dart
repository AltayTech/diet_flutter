import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/onboard/bloc.dart';
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
  late OnboardBloc bloc;
  int _index = 0;
  late List<Color> pageColor = [
    Color(0xff321E6C),
    Color(0xff0E8562),
    Color(0xffD02B2B),
  ];

  @override
  void initState() {
    super.initState();
    bloc = OnboardBloc();
    bloc.getSlider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fillPage() {
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
          height: 10.h,
          width: 70.w,
          padding: EdgeInsets.only(top: 0, left: 10.w, right: 10.w)),
      decoration: PageDecoration(
          pageColor: Color(0xff5342C3),
          imageFlex: 0,
          bodyFlex: 1,
          bodyPadding: EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w),
          imagePadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          titleTextStyle: typography.headline5!.copyWith(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold),
          bodyTextStyle: typography.caption!
              .copyWith(color: Colors.white, fontFamily: 'yekan')),
    ));
    pages.add(PageViewModel(
      titleWidget: ImageUtils.fromLocal("assets/images/onboarding/t2.svg",
          height: 15.h,
          width: 40.w,
          padding: EdgeInsets.only(left: 25.w, right: 25.w)),
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
              context: context,
              color: Color(0xff0E8562),
              child: showChampion());
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
          titleTextStyle: typography.headline5!.copyWith(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold),
          bodyTextStyle: typography.caption!
              .copyWith(color: Colors.white, fontFamily: 'yekan')),
    ));
    pages.add(PageViewModel(
      titleWidget: ImageUtils.fromLocal("assets/images/onboarding/t3.svg",
          height: 15.h,
          width: 50.w,
          padding: EdgeInsets.only(left: 20.w, right: 20.w)),
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
          titleTextStyle: typography.headline5!.copyWith(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold),
          bodyTextStyle: typography.caption!
              .copyWith(color: Colors.white, fontFamily: 'yekan')),
    ));
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
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14.sp),
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
                          style: typography.caption!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          '21 کیلوگرم کاهش وزن',
                          softWrap: false,
                          textAlign: TextAlign.start,
                          style: typography.caption!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                Icon(Icons.chevron_right_outlined,
                    color: Colors.white24, size: 35),
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
          decoration: AppDecorations.boxSmall.copyWith(
              color: Color(0x2531E6B0),
              border: Border.all(color: Color(0xaa104e40))),
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
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
