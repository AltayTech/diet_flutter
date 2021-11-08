import 'dart:math' as math;

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';


import 'arc.dart';

enum RulerType { Weight, Normal }

class CustomRuler extends StatefulWidget {
  int? value;
  final int max;
  final int min;
  final String heading;
  final String unit;
  final Color color;
  final String iconPath;
  Function helpClick;
  final RulerType rulerType;
  int? secondValue = 100;
  Function? callback;
  final gramList = List<int>.generate(10, (index) => (index) * 100);

//  final double itemExtent;

  CustomRuler({
    required this.value,
    required this.max,
    required this.min,
    required this.heading,
    required this.unit,
    required this.color,
    required this.helpClick,
    required this.iconPath,
    required this.rulerType,
    this.callback,
    this.secondValue,
  });

  @override
  _CustomRulerState createState() => _CustomRulerState();
}

class _CustomRulerState extends ResourcefulState<CustomRuler> {
  bool showRuler = false;

/*  _CustomRulerState(){
    if(widget.rulerType==RulerType.Weight && widget.secondValue == null)
      widget.secondValue = widget.gramList[0];
  }*/

  void callBack(val) {
    setState(() {
      if (val != widget.value) {
        widget.value = val;
        if (widget.rulerType == RulerType.Weight) {
          widget.callback!(val + (widget.secondValue! / 1000));
        } else
          widget.callback!(val);
      }
    });
  }

  void callBack2(secondVal) {
    setState(() {

      widget.secondValue = secondVal;

      widget.callback!(widget.value! + (secondVal / 1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Row(children: [
             SvgPicture.asset(widget.iconPath, width: 5.w, height: 5.h),
             Padding(
               padding: const EdgeInsets.only(right: 12.0),
               child: Text(widget.heading),
             ),
           ]),
            InkWell(
              child: SvgPicture.asset('assets/images/physical_report/guide.svg',
                  width: 5.w, height: 5.h),
              onTap: () => widget.helpClick.call(),
            ),
          ]),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                child: RulerBackground(
                  unit: widget.unit,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return constraints.isTight
                          ? Container()
                          : Directionality(
                        textDirection: TextDirection.ltr,
                            child: Slider(
                              color: widget.color,
                        minValue: widget.min,
                        maxValue: widget.max,
                        value: widget.value!,
                        width: constraints.maxWidth,
                        onClick: (val) {
                            callBack(val);
                        },
                        rulerType: widget.rulerType,
//                  itemExtent: itemExtent,
                      ),
                          );
                    },
                  ),
                ),
              ),
            ),
            if (widget.rulerType == RulerType.Weight)
              // SizedBox(width: AppSizes.iconDefault),
            if (widget.rulerType == RulerType.Weight)
              Flexible(
                child: Container(
                  child: RulerBackground(
                    unit: intl.gr,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return constraints.isTight
                            ? Container()
                            : Directionality(
                          textDirection: TextDirection.ltr,
                              child: Slider(
                                color: widget.color,
                          minValue: widget.min,
                          maxValue: widget.max,
                          value: widget.value!,
                          width: constraints.maxWidth,
                          onClick: (val) {
                            callBack2(val);
                          },
                          rulerType: widget.rulerType,
//                  itemExtent: itemExtent,
                        ),
                            );
                      },
                    ),
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: AppColors.grey.withOpacity(0.6),//
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   height: AppSizes.iconDefault * 12.5,
              //   padding: EdgeInsets.symmetric(
              //       horizontal: AppSizes.iconDefault * 3),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       FittedBox(
              //         child: Text(
              //           'gr',//
              //           textAlign: TextAlign.center,
              //           // style: Utils.styleTextTreadmillRulerTitle.copyWith(
              //           //     color: AppColors.grey),//
              //         ),
              //       ),
              //       // SizedBox(height: SizeConfig.blockSizeVertical * 1),
              //       Directionality(
              //         textDirection: TextDirection.rtl,
              //         child: DropdownButton(
              //           items: widget.gramList
              //               .map((value) => DropdownMenuItem(
              //             child: Text(
              //               value.toString(),
              //               textAlign: TextAlign.start,
              //             ),
              //             value: value,
              //           ))
              //               .toList(),
              //           onChanged: (dynamic val) {
              //             setState(() {
              //               callBack2(val);
              //             });
              //           },
              //           value: widget.secondValue,
              //           // style: Utils.styleTextTreadmillRulerTitle,
              //           underline: Container(color: Colors.transparent),
              //           dropdownColor: Colors.white,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
          ],
        ),
      ],
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }
}

class Slider extends StatelessWidget {
  final Color color;
  final int minValue;
  final int maxValue;
  int value;
  final double width;
  final ScrollController scrollController;
  final Function? onClick;
  final RulerType rulerType;
  late BuildContext ctx;

  Slider({
    Key? key,
    required this.color,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.width,
    required this.rulerType,
    this.onClick,
//        @required this.itemExtent
  })  : scrollController = new ScrollController(
    initialScrollOffset: (value - minValue) *
        width /
        (rulerType == RulerType.Weight ? 7 : 9),
  ),
        super(key: key);

  double get itemExtent => width / (rulerType == RulerType.Weight ? 3 : 9); //space between number

  int _indexToValue(int index) =>
      minValue + (index - (rulerType == RulerType.Weight ? 7 : 4));

  @override
  build(BuildContext context) {
    ctx = context;
    int itemCount =
        (maxValue - minValue) + (rulerType == RulerType.Weight ? 7 : 9);
    return NotificationListener(
      onNotification: _onNotification,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: new ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemExtent: itemExtent,
          itemCount: itemCount,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            int itemValue = _indexToValue(index);
            // Fimber.d('value ${widget.value} / $itemValue}');
            bool isExtra;
            if (rulerType == RulerType.Weight)
              isExtra = index == 0 ||
                  index == 1 ||
                  index == 2 ||
                  index == itemCount - 1 ||
                  index == itemCount - 2 ||
                  index == itemCount - 3;
            else
              isExtra = index == 0 ||
                  index == 1 ||
                  index == 2 ||
                  index == 3 ||
                  index == itemCount - 4 ||
                  index == itemCount - 1 ||
                  index == itemCount - 2 ||
                  index == itemCount - 3;

            return isExtra
                ? new Container() //empty first and last element
                : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _animateTo(itemValue, durationMillis: 50),
              child: Column(
                children: <Widget>[
                  Row(children: [
                    if (rulerType != RulerType.Weight)
                      Row(children: [
                        intent(Offset(9,0)),
                        intent(Offset(16,0)),
                        intent(Offset(24,0)),
                        intent(Offset(30,0)),
                      ]),
                    Container(
                      color: itemValue == value
                          ? color
                          : AppColors.penColor
                          .withOpacity(0.6),
                      width: itemValue == value ? 2 : 1,
                      height: itemValue == value
                          ? AppSizes.iconDefault
                          : AppSizes.iconSmall,
                    ),
                  ]),
                  SizedBox(height: AppSizes.iconDefault * 1),
                  Text(
                    itemValue.toString(),
                    // style: _getTextStyle(itemValue, value),
                    style: _getDefaultTextStyle(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget intent(Offset offset){
    return  Transform.translate(
      offset: offset,
      child: Container(
        color: AppColors.penColor
            .withOpacity(0.3),
        width: 1,
        height: AppSizes.iconSmall * 0.5,
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(196, 196, 196, 1.0),
      fontSize: 14,
    );
  }

  TextStyle _getHighlightTextStyle(BuildContext context) {
    return new TextStyle(
      color: AppColors.grey,//
      fontSize: 14,
    );
  }

  // TextStyle _getTextStyle(int itemValue, int value) {
  //   // Fimber.d('style $itemValue/ $value');
  //   return itemValue == value
  //       ? Utils.styleTextTreadmillRulerActiveNumber
  //       : Utils.styleTextTreadmillRulerInactiveNumber;
  // }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
    // widget.onChanged(valueToSelect);
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        value = middleValue;
        onClick!(middleValue);
        // onClick(middleValue, widget.type);
        (ctx as Element).markNeedsBuild();
        //Fimber.d('new ill $value');
        // widget.onChanged(middleValue);
        // setState(() {
        //   widget.value = middleValue;
        // });
        // Fimber.d('new value $value / $middleValue');
      }
    }
    return true;
  }
}

class RulerBackground extends StatelessWidget {
  final Widget? child;
  final String? unit;

  const RulerBackground({this.unit, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0.0),
            height: AppSizes.iconDefault * 5,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.6), //
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: child,
          ),
          Positioned(
              top: 5.h,
              child: Container(
              width: 20.w,
              height: 15.h,
              decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.6), // border color
              shape: BoxShape.circle),
              child: Transform.translate(
                offset: Offset(0,8.h),
                  child: Text(unit!,textAlign: TextAlign.center,style: TextStyle(fontSize: 12.sp)))))
        ],
      ),
    );
  }
}
