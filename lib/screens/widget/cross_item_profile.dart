import 'package:behandam/base/utils.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';

class CrossItemProfile extends StatelessWidget {
  late String imageAddress;
  late String text;
  late bool space;
  late String url;
  late BuildContext context;

  CrossItemProfile(
      {required this.imageAddress,
      required this.text,
      required this.space,
      required this.url,
      required this.context});

  Widget _crossItem() {
    return  MaterialButton(
        onPressed: () {
          print('clicked');
          Utils.launchURL(url);
        },shape: AppShapes.rectangleDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            space ? SizedBox(height: 1.5.h) : Container(),
            ImageUtils.fromLocal(
              imageAddress,
              width: 8.w,
              height: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _crossItem();
  }
}
