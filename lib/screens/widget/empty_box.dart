import 'package:flutter/material.dart';

/// An empty widget to show when no data is available
/// [predicate] is data you use to display in [child]
/// when [predicate] is of bool type it shows [child] only when it is true
/// when [predicate] io not of bool type is shows [child] only when it is not null
class EmptyBox<T> extends StatelessWidget {
  EmptyBox({
    this.child,
    this.predicate,
  });

  final T? predicate;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return predicateIsSatisfied() ? (child ?? SizedBox.shrink()) : SizedBox.shrink();
  }

  bool predicateIsSatisfied() {
    return (predicate != null && predicate !is bool) || (predicate == true);
  }
}
