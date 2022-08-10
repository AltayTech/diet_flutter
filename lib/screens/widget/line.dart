import 'package:flutter/material.dart';

class Line extends Container {
  Line({double? width, double? height, required Color color})
      : super(width: width, height: height, color: color);
}
class MyLine extends CustomPainter {
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width, size.height / 5);
    final p2 = Offset(0, size.height - 5);
    final paint = Paint()
      ..color = Color(0xff454545)
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}