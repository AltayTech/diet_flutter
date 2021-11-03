import 'package:flutter/material.dart';

class FoodListCurve extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height * 0.85);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.85);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}