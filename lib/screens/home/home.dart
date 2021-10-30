import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ResourcefulState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          body:  Container(
            height: 100.h,
            child: Stack(children: [
              Positioned(
                bottom: 0,
                child: BottomNav(currentTab: BottomNavItem.PROFILE,),
              )
            ]),
          ),
      ),
    );
  }
}
