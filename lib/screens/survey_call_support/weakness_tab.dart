import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class WeaknessTab extends StatefulWidget {
  WeaknessTab() {}

  @override
  _WeaknessTabState createState() => _WeaknessTabState();
}

class _WeaknessTabState extends ResourcefulState<WeaknessTab> {
  bool showOpenDialog = false;

  late TicketBloc ticketBloc;

  @override
  void initState() {
    super.initState();
    ticketBloc = TicketBloc();
    // _scrollControllerStatus.animateTo(0, duration: duration, curve: curve)
  }

  @override
  void dispose() {
    ticketBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return body();
  }

  Widget body() {
    return Container(
      decoration: AppDecorations.boxSmall.copyWith(
        color: Colors.white,
      ),
      child: content(),
    );
  }

  Widget content() {
    return Container();
  }

  @override
  void onRetryLoadingPage() {

  }
}
