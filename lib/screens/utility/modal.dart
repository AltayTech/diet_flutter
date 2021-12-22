import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class Popover extends StatelessWidget {
  const Popover({
    Key? key,
    Widget? child,
  }) : child = child ?? '';

  final child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          _buildHandle(context),
          if (child != null)
            child
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    return FractionallySizedBox(
      // widthFactor: 0.25,
      child: Container(
        // margin: const EdgeInsets.symmetric(
        //   vertical: 16.0,
        // ),
        // child: Container(
        //   height: 5.0,
        //   decoration: BoxDecoration(
        //     color: theme.dividerColor,
        //     borderRadius: const BorderRadius.all(Radius.circular(2.5)),
        //   ),
        // ),
      ),
    );
  }
}