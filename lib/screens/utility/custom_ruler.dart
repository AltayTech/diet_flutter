import 'dart:math' as math;

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/screens/regime/provider.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/regime/ruler_header.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logifan/widgets/space.dart';

enum RulerType { Weight, Normal, Pregnancy }

class CustomRuler extends StatefulWidget {
  final Color color;
  int value;
  final int max;
  final int min;
  final Function onClick;
  final Function? onClickSecond;
  final String unit;
  final String? secondUnit;
  final RulerType rulerType;
  final String heading;
  final Function helpClick;
  final String iconPath;
  int? secondValue;
  // Function? hideBtn;

  CustomRuler({
    required this.color,
    required this.value,
    this.secondValue,
    required this.max,
    required this.min,
    required this.unit,
    this.secondUnit,
    required this.rulerType,
    required this.heading,
    required this.helpClick,
    required this.iconPath,
    required this.onClick,
    this.onClickSecond,
    // this.hideBtn,
  });

  @override
  _CustomRulerState createState() => _CustomRulerState();
}

class _CustomRulerState extends ResourcefulState<CustomRuler> {
  bool showRuler = false;
  late RegimeBloc bloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = RegimeProvider.of(context);

    return RegimeProvider(
      bloc,
      child: Container(
        height: 20.h,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RulerHeader(
                      iconPath: widget.iconPath,
                      heading: widget.heading,
                      onHelpClick: widget.helpClick,
                    ),
                  ),
                  if (widget.rulerType == RulerType.Pregnancy) Space(width: 3.w),
                  if (widget.rulerType == RulerType.Pregnancy)
                    Expanded(
                      child: Text(
                        intl.multiBirth,
                        style: typography.subtitle2,
                      ),
                    ),
                ],
              ),
            ),
            Space(height: 1.5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                meter(),
                if (widget.rulerType != RulerType.Normal) Space(width: 3.w),
                if (widget.rulerType != RulerType.Normal) meter(isSecond: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget meter({bool isSecond = false}) {
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
                          child: Stack(
                            children: [
                              Slider(
                                color: widget.color,
                                minValue: isSecond
                                    ? widget.rulerType == RulerType.Weight
                                    ? 0
                                    : 1
                                    : widget.min,
                                maxValue: isSecond
                                    ? widget.rulerType == RulerType.Weight
                                    ? 9
                                    : 6
                                    : widget.max,
                                value: isSecond
                                    ? widget.secondValue!
                                    : widget.value,
                                onChanged: (val) {
                                  setState(() {
                                    if (isSecond) {
                                      widget.onClickSecond?.call(val);
                                      widget.secondValue = val;
                                      // print(
                                      // 'ruler value 1: $val / ${widget.secondValue}');
                                    } else {
                                      widget.onClick.call(val);
                                      widget.value = val;
                                      // print(
                                      //     'ruler value 1:: $val / ${widget.value}');
                                    }
                                  });
                                },
                                width: constraints.maxWidth,
                                type: widget.rulerType,
                                isSecond: isSecond,
                              ),
                              Positioned(
                                top: -27,
                                right: 0,
                                left: 0,
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 15.w,
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
            if (widget.rulerType != RulerType.Pregnancy ||
                (widget.rulerType == RulerType.Pregnancy && !isSecond))
              Container(
                width: 18.w,
                height: 2.8.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.box,
                    borderRadius: BorderRadius.only(
                      bottomLeft: AppRadius.radiusExtraLarge,
                      bottomRight: AppRadius.radiusExtraLarge,
                    ),
                  ),
                  child: Text(
                    isSecond ? widget.secondUnit ?? '' : widget.unit,
                    textAlign: TextAlign.center,
                    style: typography.caption?.apply(
                      color: AppColors.labelColor,
                      fontSizeDelta: -3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}

class Slider extends StatefulWidget {
  final int minValue;
  final int maxValue;
  int value;
  final ValueChanged<int> onChanged;
  final double width;
  final ScrollController scrollController;
  final Color color;
  final RulerType type;
  final bool isSecond;
  Slider(
      {required this.minValue,
      required this.maxValue,
      required this.value,
      required this.onChanged,
      required this.width,
      required this.color,
      required this.type,
      this.isSecond = false})
      : scrollController = new ScrollController(
            initialScrollOffset: (value - minValue) *
                width /
                (type == RulerType.Normal ? 9 : 5));

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  late RegimeBloc bloc;
  late int newValue;
  // late ScrollController scrollController;
  double get itemExtent =>
      widget.width / (widget.type == RulerType.Normal ? 9 : 5);

  List gramList = List<int>.generate(10, (index) => index * 100);

  int _indexToValue(int index) =>
      widget.minValue + (index - ((widget.type == RulerType.Normal ? 4 : 2)));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = RegimeProvider.of(context);
    // scrollController = ScrollController(
    //     initialScrollOffset: (value - minValue) *
    //         width /
    //         (type == RulerType.Normal ? 9 : 5));
  }

  @override
  build(BuildContext context) {
    int itemCount = (widget.maxValue - widget.minValue) +
        (widget.type == RulerType.Normal ? 9 : 5);

    return NotificationListener(
      onNotification: _onNotification,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: StreamBuilder(
          stream: bloc.physicalInfo,
          builder: (_, AsyncSnapshot<PhysicalInfoData> snapshot) {
            if (snapshot.hasData) {
              newValue = widget.value;
              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: ListView.builder(
                  controller: widget.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: itemExtent,
                  itemCount: itemCount,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    int itemValue = _indexToValue(index);
                    bool isExtra;
                    if (widget.type == RulerType.Normal) {
                      isExtra = index == 0 ||
                          index == 1 ||
                          index == 2 ||
                          index == 3 ||
                          index == itemCount - 4 ||
                          index == itemCount - 1 ||
                          index == itemCount - 2 ||
                          index == itemCount - 3;
                    } else {
                      isExtra = index == 0 ||
                          index == 1 ||
                          index == itemCount - 1 ||
                          index == itemCount - 2;
                    }
                    return isExtra
                        ? Container() //empty first and last element
                        : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _animateTo(itemValue, durationMillis: 50),
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color.fromARGB(255, 174, 174, 174),
                            width: 0.5.w,
                            height: 3.h,
                          ),
                          Space(height: 1.w),
                          FittedBox(
                            child: Text(
                              widget.type == RulerType.Weight &&
                                  widget.isSecond
                                  ? (itemValue * 100).toString()
                                  : itemValue.toString(),
                              style: _getTextStyle(
                                  context, itemValue, widget.color),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return Progress();
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
    return itemValue == newValue
        ? _getHighlightTextStyle(context, color)
        : _getDefaultTextStyle();
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
  }

  int _offsetToMiddleIndex(double offset) =>
      (offset + widget.width / 2) ~/ itemExtent;

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

      if (middleValue != newValue) {
        setState(() {
          widget.value = middleValue;
          newValue = middleValue;
        }); //update selection
        widget.onChanged(middleValue);
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
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.box,
            borderRadius: new BorderRadius.circular(20.0),
          ),
          child: child,
        ),
      ],
    );
  }
}
