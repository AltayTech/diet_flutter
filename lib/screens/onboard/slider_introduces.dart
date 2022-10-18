import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/extensions/double.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/data/entity/slider/slider.dart' as sliderModel;

class SliderIntroduces extends StatefulWidget {
  late List<sliderModel.SliderIntroduces> introduces;

  SliderIntroduces({required this.introduces});

  @override
  State<SliderIntroduces> createState() => _SliderIntroducesState();
}

class _SliderIntroducesState extends State<SliderIntroduces> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        CarouselSlider(
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            height: 450,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              disableCenter: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              initialPage: 1,
              pageSnapping: true,
              scrollDirection: Axis.horizontal),
          items: widget.introduces.map((value) {
            //calculate weightLoss user
            double weightLoss = value.old_weight! - value.new_weight!;

            return Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: ImageUtils.fromLocal(
                        value.media!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Space(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            buttonCarouselController.previousPage();
                          },
                          child: Icon(
                            Icons.chevron_left_outlined,
                            color: Colors.white24,
                            size: 35,
                          ),
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value.fullName!,
                                    textAlign: TextAlign.start,
                                    softWrap: false,
                                    style: context.typography.caption!.copyWith(
                                        fontFamily: 'yekan',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text.rich(
                                    softWrap: false,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: weightLoss.toStringAsFixedOneWithoutZero,
                                            style: context.typography.caption!.copyWith(
                                                fontFamily: 'yekan',
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w900)),
                                        TextSpan(
                                          text: context.intl.kiloGr,
                                          style: context.typography.caption!.copyWith(
                                              fontFamily: 'yekan',
                                              color: Colors.white,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        TextSpan(
                                            text: context.intl.weightLoss,
                                            style: context.typography.caption!.copyWith(
                                                fontFamily: 'yekan', color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        InkWell(
                            onTap: () {
                              buttonCarouselController.nextPage();
                            },
                            child: Icon(Icons.chevron_right_outlined,
                                color: Colors.white24, size: 35)),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
