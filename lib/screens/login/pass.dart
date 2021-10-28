import 'package:flutter/material.dart';

import '../../helper/Arc.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _text = TextEditingController();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              // alignment: Alignment.center,
              // fit: StackFit.loose,
              overflow: Overflow.visible,
              children: [
                RotatedBox(quarterTurns: 90, child: MyArc(diameter: 350)),
                Positioned(
                  top: 50.0,
                  right: 150.0,
                  child: Center(
                    child: SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: AssetImage('assets/img-01.jpg')),
                    ),
                  ),
                ),
                Positioned(
                  top: 100.0,
                  right: 100.0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage('assets/img-01.jpg'),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Color(0xff191C32))),
              onChanged: (txt) {
                // number = txt;
              },
            ),
            TextField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'رمز عبورتو وارد کن',
                  labelStyle: TextStyle(color: Color(0xff191C32))),
              onChanged: (txt) {
                // number = txt;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xff191C32)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Color(0xff191C32))))),
                child: Text('ورود'),
                onPressed: () async {
                  setState(() {
                    _text.text.isEmpty ? _validate = true : _validate = false;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
