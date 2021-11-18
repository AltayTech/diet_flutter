import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

Widget alert(String txt){
  return  Column(
    children: [
      Container(
        width: (200 / 100) * 30,
        height: (200 / 60) * 10,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70.0),
                  topRight: Radius.circular(70.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ImageUtils.fromLocal('assets/images/diet/exclamation.svg'),
            )
        ),
      ),
      Container(
          width: 100.w ,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.orange[100],
          ),
          child: Center(child: Text(txt,style: TextStyle(fontSize: 16.0, color: Colors.orange[800])))
      ),
    ],
  );
}