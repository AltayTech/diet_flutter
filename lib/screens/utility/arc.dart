import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class MyArc extends StatelessWidget {
  final double? diameter;

  const MyArc({this.diameter});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(context),
      size: Size(diameter!, diameter!),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  final BuildContext ctx;

  MyPainter(this.ctx);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = AppColors.arcColor;
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.45);
    //path.lineTo(size.width * 0.5, size.height * 0.5);

    /* path.quadraticBezierTo(
        size.width * 0.2 , size.height * 0.3, size.width * 0.5, size.height * 0.3);*/

    path.quadraticBezierTo(size.width * 0.5, size.height * 0.65, size.width, size.height * 0.45);

    path.lineTo(size.width, size.height * 0.45);

    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
