import 'package:flutter/material.dart';

class PayDiamondEn extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
//    path.quadraticBezierTo(
//        size.width * 0.8, size.height / 2, size.width * 0.9, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.1, size.height);
    path.lineTo(size.width * 0.15, size.height/2);
    path.lineTo(size.width * 0.1, 0);
   // path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}
class PayDiamond extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.9, 0);
//    path.quadraticBezierTo(
//        size.width * 0.8, size.height / 2, size.width * 0.9, size.height);
    path.lineTo(size.width * 0.85, size.height / 2);
    path.lineTo(size.width * 0.9, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.9, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}