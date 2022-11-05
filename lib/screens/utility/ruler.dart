import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/utility/ruler_header.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Ruler extends StatefulWidget {
  final Color color;
  String value;
  final int max;
  final int min;
  final Function onClick;
  final String unit;
  final String? secondUnit;
  final RulerType rulerType;
  final String heading;
  final Function helpClick;
  final String iconPath;

  // Function? hideBtn;

  Ruler({
    required this.color,
    required this.value,
    required this.max,
    required this.min,
    required this.unit,
    this.secondUnit,
    required this.rulerType,
    required this.heading,
    required this.helpClick,
    required this.iconPath,
    required this.onClick,

    // this.hideBtn,
  });

  @override
  _CustomRulerState createState() => _CustomRulerState();
}

class _CustomRulerState extends ResourcefulState<Ruler> {
  bool showRuler = false;
  final _text = TextEditingController();
  GlobalKey<_SliderState> sliderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 23.h,
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: RulerHeader(
              color: widget.color,
              value: '${widget.value}',
              heading: widget.heading,
              onHelpClick: widget.helpClick,
            ),
          ),
          Space(height: 1.5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              meter(),
            ],
          ),
        ],
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
                                key: sliderKey,
                                color: widget.color,
                                minValue: widget.min,
                                maxValue: widget.max,
                                value: widget.value==
                                    '${widget.rulerType == RulerType.Weight ? 0.0 : 0}'
                                    ? '${widget.rulerType == RulerType.Weight ? (widget.max - widget.min) / 2 : (widget.max - ((widget.max - widget.min) / 2)).round()}'
                                    : widget.value,
                                onChanged: (val) {
                                  setState(() {
                                    widget.onClick.call(val);
                                    widget.value = '$val';
                                    _text.clear();
                                    _text.text = '${val}'.split('.')[0];
                                  });
                                },
                                width: constraints.maxWidth,
                                type: widget.rulerType,
                                isSecond: isSecond,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Icon(
                                  Icons.arrow_drop_up_rounded,
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
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 18.w,
                    height: 5.h,
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.all(AppRadius.radiusVerySmall),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _text,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(3),
                            ],
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              counterStyle: TextStyle(fontSize: 0.sp),
                              contentPadding: EdgeInsets.only(left: 15, bottom: 16, right: 15),
                            ),
                            style: typography.caption?.apply(
                              color: widget.color,
                            ),
                            onSubmitted: (txt) {
                              if (widget.max >= int.parse(txt) && widget.min <= int.parse(txt)) {
                                if (widget.secondUnit != null)
                                  sliderKey.currentState!
                                      .scrollTo('$txt.${widget.value.toString().split('.')[1]}');
                                else
                                  sliderKey.currentState!.scrollTo('$txt');
                              } /* else if (widget.max < int.parse(txt)) {
                                sliderKey.currentState!.scrollTo('${widget.max}.0');
                              } else {
                                sliderKey.currentState!.scrollTo('${widget.min}.0');
                              }*/
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
                          decoration: BoxDecoration(
                            color: AppColors.box,
                            borderRadius: BorderRadius.all(AppRadius.radiusVerySmall),
                          ),
                          child: Text(
                            widget.unit,
                            textAlign: TextAlign.center,
                            style: typography.caption?.apply(
                              color: widget.color,
                              fontSizeDelta: -3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.secondUnit != null)
                  Space(
                    width: 2.w,
                  ),
                if (widget.secondUnit != null) gram(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget gram() {
    return Expanded(
      flex: 1,
      child: Container(
        width: 18.w,
        height: 5.h,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.all(AppRadius.radiusVerySmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        color: Color(0xff454545),
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.add),
                        iconSize: 20,
                        onPressed: () {
                          if (double.parse(widget.value.toString().split('.')[1]) < 900 && double.parse(widget.value.toString().split('.')[0])<widget.max) {
                            setState(() {
                              widget.value =
                                  '${(double.parse(widget.value) + 0.100).toStringAsFixed(1)}00';
                              sliderKey.currentState!.scrollTo('${widget.value}');
                            });
                          } else
                            return;
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${widget.value.toString().split('.')[1]}',
                        textAlign: TextAlign.center,
                        softWrap: false,
                        style: typography.caption?.apply(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        color: Color(0xff454545),
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.remove),
                        iconSize: 20,
                        onPressed: () {
                          if (double.parse(widget.value.toString().split('.')[1]) > 0 ) {
                            setState(() {
                              widget.value =
                                  '${(double.parse(widget.value) - 0.100).toStringAsFixed(1)}${(double.parse(widget.value.toString().split('.')[1]) - 100 > 0) ? '00' : ''}';
                              sliderKey.currentState!.scrollTo('${widget.value}');
                            });
                          }
                        }),
                  ),
                ],
              ),
              flex: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.w, bottom: 1.w),
              decoration: BoxDecoration(
                color: AppColors.box,
                borderRadius: BorderRadius.all(AppRadius.radiusVerySmall),
              ),
              child: Text(
                widget.secondUnit!,
                textAlign: TextAlign.center,
                style: typography.caption?.apply(
                  color: widget.color,
                  fontSizeDelta: -3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Slider extends StatefulWidget {
  final int minValue;
  final int maxValue;
  String value;
  final ValueChanged<Object> onChanged;
  final double width;
  final Color color;
  final RulerType type;
  final bool isSecond;
  final Key? key;

  Slider(
      {this.key,
      required this.minValue,
      required this.maxValue,
      required this.value,
      required this.onChanged,
      required this.width,
      required this.color,
      required this.type,
      this.isSecond = false})
      : super(key: key);

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  int indexSelected = 0;
  List _list = [];
  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == RulerType.Weight) {
      for (int i = widget.minValue; i <= widget.maxValue; i++) {
        _list.add('$i.0');
        if (i < widget.maxValue)
          for (int g = 1; g <= 9; g++) {
            _list.add('$i.${(g * 100)}');
          }
      }
    } else {
      for (int i = widget.minValue; i <= widget.maxValue; i++) {
        _list.add('$i');
      }
    }
    int index = 0;
    _list.forEach((element) {
      if (element == '${widget.value}') {
        indexSelected = index;
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            indexSelected;
          });
        });
      }
      index++;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ScrollSnapList(
          itemSize: 5.w,
          focusOnItemTap: true,
          curve: Curves.ease,
          key: sslKey,
          initialIndex: indexSelected.toDouble(),
          onItemFocus: (val) {
            setState(() {
              indexSelected = val;
            });
            widget.onChanged.call(_list[indexSelected]);
          },
          itemBuilder: (context, index) {
            return SizedBox(
              width: index % 10 == 0 ? 5.w : 5.w,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => sslKey.currentState!.focusToItem(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: index == indexSelected
                            ? widget.color
                            : Color.fromARGB(255, 174, 174, 174),
                        width: 0.5.w,
                        height: (index % 10 == 0 || index == indexSelected) ? 4.h : 2.h,
                      ),
                      Space(height: 1.w),
                      FittedBox(
                        child: Text(
                          index % 10 == 0 ? _list[index].toString().split('.')[0] : ' ',
                          style: _getTextStyle(context, index, widget.color),
                        ),
                      ),
                      if (index == indexSelected) Spacer()
                    ],
                  )),
            );
          },
          itemCount: _list.length,
          reverse: false,
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
      fontSize: 1.sp,
    );
  }

  TextStyle _getTextStyle(BuildContext context, int index, Color color) {
    return index == indexSelected ? _getHighlightTextStyle(context, color) : _getDefaultTextStyle();
  }

  void scrollTo(String value) {
    int index = 0;
    _list.forEach((element) {
      if (element == '$value') {
        sslKey.currentState!.focusToItem(index);
        setState(() {
          indexSelected = index;
        });
      }
      index++;
    });
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
          height: 9.h,
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
