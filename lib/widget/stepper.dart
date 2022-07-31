import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Created by Luciferx86 on 08/09/20.
class ProgressTimeline extends StatefulWidget {
  /// a List of all states to be rendered
  final List<SingleState> states;

  /// height of the widget
  final double height;

  /// width of the widget
  final double width;

  /// Icon used to render a checked stage
  final Widget checkedIcon;

  /// Icon used to render current stage
  final Widget currentIcon;

  /// Icon used to render a failed stage
  final Widget failedIcon;

  /// Icon used to render an unchecked stage
  final Widget uncheckedIcon;

  /// Color of the connectors
  final Color? connectorColor;

  final Color? connectorColorSelected;

  /// Length of the connectors
  final double connectorLength;

  /// Width of the connectors
  final double connectorWidth;

  ///Size of Icons rendered in each stage
  final double iconSize;

  /// Style of text used to display stage title
  final TextStyle? textStyle;

  /// Curve for Transition can be added, defaults to
  final Curve transitionCurve;

  ProgressTimeline({
    required this.states,
    required this.height,
    required this.width,
    required this.checkedIcon,
    required this.currentIcon,
    required this.failedIcon,
    required this.iconSize,
    this.textStyle,
    required this.connectorLength,
    required this.connectorWidth,
    this.connectorColor,
    this.connectorColorSelected,
    required this.uncheckedIcon,
    this.transitionCurve = Curves.fastOutSlowIn,
  });

  final _ProgressTimelineState state = new _ProgressTimelineState();

  /// method to jump to next stage in the process.
  void gotoNextStage() {
    state.gotoNextStage();
  }

  void gotoStage(int page) {
    state.gotoStage(page);
  }

  /// method to mark the current stage as failed.
  void failCurrentStage() {
    state.failCurrentStage();
  }

  /// method to go back to previous stage in the process.
  void gotoPreviousStage() {
    state.gotoPreviousStage();
  }

  @override
  _ProgressTimelineState createState() => state;
}

class _ProgressTimelineState extends State<ProgressTimeline> {
  int currentStageIndex = 0;
  late List<SingleState> states;
  double height = 100;

  final _controller = ItemScrollController();

  @override
  void initState() {
    states = widget.states;
    if (widget.height != null) {
      height = widget.height;
    }
    super.initState();
  }

  void gotoNextStage() {
    setState(() {
      if (currentStageIndex <= states.length - 1) {
        currentStageIndex++;
        _controller.scrollTo(
          index: currentStageIndex - 1,
          duration: Duration(milliseconds: 1000),
          curve: widget.transitionCurve,
        );
      }
    });
  }

  void gotoPreviousStage() {
    setState(() {
      if (currentStageIndex >= 0) {
        if (currentStageIndex > 0) currentStageIndex--;
        states[currentStageIndex].isFailed = false;
      }

      if (currentStageIndex > 0) {
        _controller.scrollTo(
          index: currentStageIndex - 1 >= 0 ? currentStageIndex - 1 : currentStageIndex,
          duration: Duration(milliseconds: 1000),
          curve: widget.transitionCurve,
        );
      }
    });
  }

  void gotoStage(int page) {
    setState(() {
      if (page <= states.length - 1) {
        currentStageIndex = page;
        _controller.scrollTo(
          index: currentStageIndex,
          duration: Duration(milliseconds: 1000),
          curve: widget.transitionCurve,
        );
      }
    });
  }

  void failCurrentStage() {
    setState(() {
      states[currentStageIndex].isFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      width: widget.width,
      child: ScrollablePositionedList.builder(
        itemCount: buildStates().length,
        itemScrollController: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return buildStates()[index];
        },
      ),
    );
  }

  List<Widget> buildStates() {
    List<Widget> allStates = [];
    for (var i = 0; i < states.length; i++) {
      allStates.add(_RenderedState(
        textStyle: widget.textStyle,
        connectorLength: widget.connectorLength,
        connectorWidth: widget.connectorWidth,
        connectorColor: widget.connectorColor,
        connectorColorSelected: widget.connectorColorSelected,
        iconSize: widget.iconSize,
        checkedIcon: widget.checkedIcon,
        failedIcon: widget.failedIcon,
        currentIcon: widget.currentIcon,
        uncheckedIcon: widget.uncheckedIcon,
        stateNumber: i + 1,
        isCurrent: i == currentStageIndex,
        isFailed: states[i].isFailed,
        isChecked: i < currentStageIndex,
        stateTitle: states[i].stateTitle,
        isLeading: i == 0,
        isTrailing: i == states.length - 1,
      ));
    }

    return allStates;
  }
}

class _RenderedState extends StatelessWidget {
  final Widget? checkedIcon;
  final Widget? currentIcon;
  final Widget? failedIcon;
  final Widget? uncheckedIcon;
  final bool isChecked;
  final String stateTitle;
  final TextStyle? textStyle;
  final bool isLeading;
  final bool isTrailing;
  final int stateNumber;
  final bool isFailed;
  final bool isCurrent;
  final double iconSize;
  final Color? connectorColor;
  final Color? connectorColorSelected;
  final double connectorLength;
  final double connectorWidth;

  _RenderedState({
    required this.isChecked,
    required this.stateTitle,
    required this.stateNumber,
    double? iconSize,
    Color? connectorColor,
    Color? connectorColorSelected,
    double? connectorLength,
    double? connectorWidth,
    TextStyle? textStyle,
    this.failedIcon,
    this.currentIcon,
    this.checkedIcon,
    this.uncheckedIcon,
    this.isFailed = false,
    required this.isCurrent,
    this.isLeading = false,
    this.isTrailing = false,
  })  : this.iconSize = iconSize ?? 25,
        this.connectorColor = connectorColor ?? Colors.green,
        this.connectorColorSelected = connectorColorSelected ?? Colors.green,
        this.connectorLength = connectorLength != null ? connectorLength / 2 : 40,
        this.connectorWidth = connectorWidth ?? 5,
        this.textStyle = textStyle ?? TextStyle();

  Widget line() {
    return Container(
      color: isChecked ? connectorColorSelected : connectorColor,
      height: connectorWidth,
      width: connectorLength,
    );
  }

/*  Widget spacer() {
    return Container(
      width: 3.0,
    );
  }*/

  Widget getCheckedIcon() {
    return this.checkedIcon != null
        ? this.checkedIcon!
        : Icon(
            Icons.check_circle,
            color: Colors.green,
            size: iconSize,
          );
  }

  Widget getFailedIcon() {
    return this.failedIcon != null
        ? this.failedIcon!
        : Icon(
            Icons.highlight_off,
            color: Colors.redAccent,
            size: iconSize,
          );
  }

  Widget getCurrentIcon() {
    return this.currentIcon != null
        ? this.currentIcon!
        : Icon(
            Icons.adjust,
            color: Colors.green,
            size: iconSize,
          );
  }

  Widget getUnCheckedIcon() {
    return this.uncheckedIcon != null
        ? this.uncheckedIcon!
        : Icon(
            Icons.radio_button_unchecked,
            color: Colors.green,
            size: iconSize,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              //if (!isLeading) line(),
              renderCurrentState(),
              if (!isTrailing) line(),
            ],
          ),
        ),
        Container(
          child: Text(
            stateTitle,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  Widget renderCurrentState() {
    if (isFailed != null && isFailed) {
      return getFailedIcon();
    } else if (isChecked != null && isChecked) {
      return getCheckedIcon();
    } else if (isCurrent != null && isCurrent) {
      return getCurrentIcon();
    }
    return getUnCheckedIcon();
  }
}

class SingleState {
  /// Do not use this explicitly(in most cases)
  bool isFailed;

  /// Title of a state
  String stateTitle;

  SingleState({required this.stateTitle, required this.isFailed});
}
