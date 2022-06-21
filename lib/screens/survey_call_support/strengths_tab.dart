import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class StrengthsTab extends StatefulWidget {
  StrengthsTab() {}

  @override
  _StrengthsTabState createState() => _StrengthsTabState();
}

class _StrengthsTabState extends ResourcefulState<StrengthsTab> {
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
    return body();/*TicketProvider(ticketBloc,
        child: Scaffold(
          backgroundColor: AppColors.newBackground,
          body: body(),
        ));*/
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
