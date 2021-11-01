import 'package:flutter/material.dart';

class CustomCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.04, size.height * 0.69,
        size.width * 0.10, size.height * 0.7);
    path.lineTo(size.width * 0.9, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.96, size.height * 0.69, size.width, size.height * 0.9);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}