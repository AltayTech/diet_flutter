import 'package:flutter/material.dart';

class BmiStatus {
  BmiStatus({this.status, required this.text, required this.imagePath, required this.color});

  int? status;
  String text;
  String imagePath;
  Color color;
}
