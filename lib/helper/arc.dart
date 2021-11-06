import 'package:flutter/material.dart';
import 'dart:math';
import 'package:behandam/themes/colors.dart';

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
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width),
        height: size.height * 1.5,
        width: MediaQuery.of(ctx).size.height,
      ),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}