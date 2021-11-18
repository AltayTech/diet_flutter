import 'dart:math' as math;

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum RulerType { Weight, Normal, Pregnancy , Twin }

class CustomRuler extends StatefulWidget {
  final Color color;
  double? value;
  final int max;
  final int min;
  Function? onClick;
  final String unit;
  final RulerType rulerType;
  final String heading;
  Function helpClick;
  final String iconPath;
  double secondValue = 0;
  Function? hideBtn;

  CustomRuler({
    required this.color,
    required this.value,
    required this.max,
    required this.min,
    required this.unit,
    required this.rulerType,
    required this.heading,
    required this.helpClick,
    required this.iconPath,
    this.onClick,
    this.hideBtn,
  });

  @override
  _CustomRulerState createState() => _CustomRulerState();
}

class _CustomRulerState extends State<CustomRuler> {
  bool showRuler = false;
  double _value = 40.0;

  void callBack(val) {
    if(widget.rulerType == RulerType.Twin && val >= 2
    || widget.rulerType == RulerType.Pregnancy && val >= 35)
      setState(() {
       widget.hideBtn!(true);
      });
    else
    setState(() {
      widget.hideBtn!(false);
      if (val != widget.value) {
        widget.value = val;
        if (widget.rulerType == RulerType.Weight) {
          widget.onClick!(val + (widget.secondValue / 1000));
        } else
          widget.onClick!(val);
      }
    });
  }

  void callBackGr(secondVal) {
    setState(() {
print(secondVal);
      widget.secondValue = secondVal;

      widget.onClick! (widget.value! + (secondVal / 1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                widget.rulerType != RulerType.Twin
                ? ImageUtils.fromLocal(widget.iconPath, width: 5.w, height: 5.h)
                : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(widget.heading,style: TextStyle(fontSize: 12.sp)),
                ),
              ]),
              widget.rulerType != RulerType.Twin
              ? InkWell(
                child: ImageUtils.fromLocal(
                    'assets/images/physical_report/guide.svg',
                    width: 5.w,
                    height: 5.h),
                onTap: () => widget.helpClick.call())
                  : Container(height: 5.h)
            ]),
            SizedBox(height: 2.h),
            Row(children: [
              if(widget.rulerType == RulerType.Twin)
              meter(widget.unit, false, true)
              else
                meter(widget.unit, false, false),
              if (widget.rulerType == RulerType.Weight)
                SizedBox(width: AppSizes.iconDefault),
              if (widget.rulerType == RulerType.Weight)
                meter('گرم', true, false),
            ]),
          ],
        ),
      ),
    );
  }
  Widget meter(String unit, bool grType, bool twinType) {
    return Flexible(
      child: Container(
        child: Column(
          children: [
            RulerBackground(
              color: widget.color,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.isTight
                      ? Container()
                      : Directionality(
                          textDirection: TextDirection.ltr,
                          child: Slider(
                            color: widget.color,
                            minValue: grType ? 0 : widget.min,
                            maxValue:  grType ? 1000 : widget.max,
                            value: widget.value!,
                            onChanged: (val) {
                              print('value: $val');
                              grType
                              ? callBackGr(double.parse(val.toString()))
                              : callBack(double.parse(val.toString()));
                            },
                            width: constraints.maxWidth,
                            isGram: grType,
                            twin : twinType
//                  itemExtent: itemExtent,
                          ),
                        );
                },
              ),
            ),
            Container(
              width: (200 / 100) * 30,
              height: (200 / 100) * 10,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.box,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70.0),
                      bottomRight: Radius.circular(70.0)),
                ),
                child: Text(
                  unit,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 169, 169, 169),
                    fontSize: (200 / 100) * 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final double value;
  final ValueChanged<int> onChanged;
  final double width;
  final ScrollController scrollController;
  final Color color;
  final bool isGram;
  final bool twin;
  double get itemExtent => width / (isGram ?19 :9);
  List gramList = List<int>.generate(10, (index) => index * 100);

  int _indexToValue(int index) => minValue + (index -  (isGram ?9 :4));
      // - (isGram ? 0 : 4)); //first

  Slider({
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    required this.width,
    required this.color,
    required this.isGram,
    required this.twin
  }) : scrollController = new ScrollController(
            initialScrollOffset: (value - minValue) * width /  (isGram ? 19 :9));

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3; //4
        // (isGram ? 0 : 9); //last
    return NotificationListener(
      onNotification: _onNotification,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: new ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemExtent: isGram || twin ? 3.w : itemExtent,
          itemCount: itemCount,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            int itemValue;
            // isGram
            // ?  itemValue = _indexToValue(index-12)
            // :
            itemValue = _indexToValue(index);
            // if(isGram){
            //   print("index:$index");
            //   print("item:$itemValue");
            // }
            bool isExtra;
            if (isGram)
              isExtra =  isExtra = index == 0 ||
                  index == 1 ||
                  index == 2 ||
                  index == 3 ||
                  index == 4 ||
                  index == 5 ||
                  index == 6 ||
                  index == 7 ||
                  index == itemCount - 1 ||
                  index == itemCount - 2 ||
                  index == itemCount - 3 ||
                  index == itemCount - 4 ||
                  index == itemCount - 5 ||
                  index == itemCount - 6 ||
                  index == itemCount - 7;
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
                        itemValue == value
                       ? Container(
                           width:1.w,
                           height: 1.h,
                           color: color)
                        : Container(),
                        Container(
                          color: isGram || twin
                              ? Color.fromARGB(255, 174, 174, 174)
                              : itemValue % 5 == 0
                                  ? Color.fromARGB(255, 174, 174, 174)
                                  : Color.fromARGB(255, 213, 213, 213),
                          width: 0.5.w,
                          height: isGram || twin
                              ? 1.5.h
                              : itemValue % 5 == 0
                                  ? 2.h
                                  : 1.h,
                        ),
                        SizedBox(height: 1.w),
                        // if (isGram)
                        //   FittedBox(
                        //     child: Text(
                        //       (itemValue*100).toString(),
                        //      // index< 10 ? gramList[index].toString() : '',
                        //       style:
                        //           _getTextStyle(context, itemValue, color),
                        //     ),
                        //   )
                          if(twin)
                          FittedBox(
                            child: Text(
                            itemValue.toString(),
                            style: _getTextStyle(
                                context, itemValue, color)
                            ),
                            )
                        else
                          itemValue % 5 == 0 || itemValue == 1 || itemValue == value
                              ? FittedBox(
                                  child: Text(
                                    itemValue.toString(),
                                    style: _getTextStyle(
                                        context, itemValue, color),
                                  ),
                                )
                              : Container(),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(196, 196, 196, 1.0),
      fontSize: 10.sp,
    );
  }

  TextStyle _getHighlightTextStyle(BuildContext context, Color color) {
    return new TextStyle(
      color: color,
      fontSize: 12.sp,
    );
  }

  TextStyle _getTextStyle(BuildContext context, int itemValue, Color color) {
    return itemValue == value
        ? _getHighlightTextStyle(context, color)
        : _getDefaultTextStyle();
  }

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
        // isGram
        // ? onChanged(gramList[index])
        // :
        onChanged(middleValue); //update selection
      }
    }
    return true;
  }
}

class RulerBackground extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const RulerBackground({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          height: (240 / 100) * 25,
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            borderRadius: new BorderRadius.circular(20.0),
          ),
          child: child,
        ),
      ],
    );
  }
}
