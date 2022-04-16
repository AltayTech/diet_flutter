import 'dart:math' as math;

import 'package:behandam/base/resourceful_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum VerticalSliderType { Number, String }
enum DateType { Day, Month, Year, Sickness }

class MySlider extends StatefulWidget {
  MySlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.height,
    required this.type,
    this.list,
    this.onClick,
    required this.verticalSliderType,
//        @required this.itemExtent
  })  : scrollController = new ScrollController(
          initialScrollOffset: (value - minValue) * height / 5,
        ),
        super(key: key) {
    list = list?.map((item) => item).toList();
  }

  int minValue;
  int maxValue;
  int value;
  VerticalSliderType verticalSliderType;
  double height;
  late ScrollController scrollController;
  Function? onClick;
  List? list;
  DateType type;

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends ResourcefulState<MySlider> {
  double get itemExtent => widget.height / 5;

  int _indexToValue(int index) => widget.minValue + (index - 2);

  @override
  build(BuildContext context) {
    super.build(context);
    int itemCount = (widget.maxValue - widget.minValue) + 5;
    return NotificationListener(
      onNotification: _onNotification,
      child: new ListView.builder(
        controller: widget.scrollController,
        scrollDirection: Axis.vertical,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          int itemValue = _indexToValue(index);
          String? itemValueString;
          bool isExtra = index == 0 ||
              index == 1 ||
              index == itemCount - 1 ||
              index == itemCount - 2;
          if (widget.verticalSliderType == VerticalSliderType.String &&
              !isExtra) {
            // int i = list.indexWhere((element) => element )
            itemValueString = widget.list![index - 2];
          }
          // Fimber.d('value ${widget.value} / $itemValue}');
          return isExtra
              ? new Container() //empty first and last element
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _animateTo(itemValue, durationMillis: 50),
                  child: Center(
                    child: Text(
                      widget.verticalSliderType == VerticalSliderType.String
                          ? itemValueString.toString()
                          : itemValue.toString(),
                      textAlign: TextAlign.center,
                      style: _getTextStyle(itemValue, widget.value),
                    ),
                  ),
                );
        },
      ),
    );
  }

  TextStyle _getTextStyle(int itemValue, int value) {
    //Fimber.d('style $itemValue/ $value');
    return itemValue == value
        ? Theme.of(context)
            .textTheme
            .caption!
            .copyWith(fontWeight: FontWeight.w600)
        : Theme.of(context).textTheme.overline!;
  }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        widget.scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - widget.minValue) * itemExtent;
    widget.scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
    // widget.onChanged(valueToSelect);
  }

  int _offsetToMiddleIndex(double offset) =>
      (offset + widget.height / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue =
        math.max(widget.minValue, math.min(widget.maxValue, middleValue));
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != widget.value) {
        //Fimber.d('middlevalue $middleValue');
        setState(() {
          widget.value = middleValue;
        });

        widget.onClick!(middleValue, widget.type);
        widget.value = middleValue;

        // widget.onChanged(middleValue);
        // setState(() {
        //   widget.value = middleValue;
        // });
        // Fimber.d('new value ${widget.value} / $middleValue');
      }
    }
    return true;
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
