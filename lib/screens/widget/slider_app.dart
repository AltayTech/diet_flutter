import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/utils/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class SliderApp extends StatefulWidget {
  late List<BannerItem> banners;

  SliderApp({required this.banners});

  @override
  State<SliderApp> createState() => _SliderAppState();
}

class _SliderAppState extends State<SliderApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CarouselSlider(
      options: CarouselOptions(
          // height: 20.h,
          autoPlayInterval: Duration(milliseconds: 500),
          disableCenter: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          enableInfiniteScroll: false,
          scrollDirection: Axis.horizontal),
      items: widget.banners
          .asMap()
          .map((key, value) => MapEntry(
              key,
              GestureDetector(
                onTap: () {
                  if (value.action_type == ActionType.deepLink) {
                    VxNavigator.of(context).push(Uri.parse('/${value.action}'));
                  } else if (value.action_type == ActionType.link) {
                    Utils.launchURL(value.action!);
                  }
                },
                child: Container(
                  width: 60.w,
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: ImageUtils.fromNetwork(
                        FlavorConfig.instance.variables['baseUrlFileShop'] + value.sliderImg,
                        fit: BoxFit.fill),
                  ),
                ),
              )))
          .values
          .toList(),
    );
  }
}
