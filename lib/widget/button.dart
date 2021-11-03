import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

Widget button(Color btnColor,String txt,Function press){
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(btnColor),
          fixedSize: MaterialStateProperty.all(Size(350.0,60.0)),
          // padding: MaterialStateProperty.all(
          //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: btnColor)))),
      child: Text(txt,style: TextStyle(fontSize: 22.0),),
      onPressed: () => press.call()
  );
}