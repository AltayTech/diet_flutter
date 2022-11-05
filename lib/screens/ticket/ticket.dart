import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class Ticket extends StatefulWidget {
  Ticket() {}

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends ResourcefulState<Ticket> {
  bool showOpenDialog = false;

  late TicketBloc ticketBloc;
  ScrollController _scrollControllerStatus = ScrollController();

  @override
  void initState() {
    super.initState();
    ticketBloc = TicketBloc();
    ticketBloc.getTickets();
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
    return TicketProvider(ticketBloc,
        child: Scaffold(
          backgroundColor: AppColors.newBackground,
          body: body(),
        ));
  }

  Widget body() {
    return SafeArea(
      child: TouchMouseScrollable(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(
              left: 4.w,
              right: 4.w,
              bottom: 5.h,
            ),
            decoration: AppDecorations.boxSmall.copyWith(
              color: Colors.white,
            ),
            child: content(),
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      textDirection: context.textDirectionOfLocale,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Space(height: 3.h),
              newTicketButton(),
              Space(height: 3.h),
            ],
          ),
        ),
        StreamBuilder(
          builder: (context, snapshot) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => Future.delayed(Duration(milliseconds: 500), _scrollToEnd));
            if (snapshot.data != null && snapshot.data == false) {
              return StreamBuilder<List<TicketItem>>(
                  stream: ticketBloc.tickets,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && ticketBloc.tempListTickets.length > 0)
                      return Container(
                        child: Column(
                          children: [
                            if (ticketBloc.tempListTickets.length > 0) listFilter(),
                            Space(height: 1.h),
                            if (snapshot.requireData.length > 0)
                              ...snapshot.requireData
                                  .map((message) => TicketItemWidget(
                                        ticketItem: message,
                                      ))
                                  .toList()
                          ],
                        ),
                      );
                    else
                      return Text(intl.noTicketAvailable, style: typography.caption);
                  });
            } else {
              return Center(
                child: Progress(size: 5.h),
              );
            }
          },
          stream: ticketBloc.progressNetwork,
        )
      ],
    );
  }

  Widget newTicketButton() {
    return GestureDetector(
      onTap: () => VxNavigator.of(context).push(Uri.parse(Routes.newTicketMessage)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ImageUtils.fromLocal(
                'assets/images/foodlist/plus.svg',
                width: 3.w,
                height: 3.w,
                fit: BoxFit.fill,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                intl.newTicket,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listFilter() {
    return SizedBox(
      height: 5.h,
      width: 100.w,
      child: StreamBuilder<int>(
          stream: ticketBloc.indexSelectedStatus,
          builder: (context, indexSelected) {
            if (indexSelected.hasData)
              return ListView.builder(
                itemBuilder: (context, index) {
                  return filterItem(index, (index == indexSelected.requireData));
                },
                shrinkWrap: true,
                controller: _scrollControllerStatus,
                reverse: true,
                itemCount: TicketStatus.values.length,
                scrollDirection: Axis.horizontal,
              );
            else
              return EmptyBox();
          }),
    );
  }

  Widget filterItem(int index, bool selected) {
    String ticketStatus = getLabelTicketStatus(TicketStatus.values[index]);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: InkWell(
          onTap: () {
            ticketBloc.setIndexSelectedStatus(index);
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 25.w),
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Center(
                child: Text(
              ticketStatus,
              style: typography.caption!.copyWith(color: selected ? AppColors.primary : null),
            )),
            decoration: AppDecorations.boxExtraLarge.copyWith(
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.labelColor,
                width: 1.0,
              ),
            ),
          )),
    );
  }

  String getLabelTicketStatus(TicketStatus status) {
    print('status = > ${status.index}');
    switch (status) {
      case TicketStatus.Resolved:
        return intl.resolved;
      case TicketStatus.Closed:
        return intl.closed;
      case TicketStatus.PendingAdminResponse:
        return intl.pendingAdminResponse;
      case TicketStatus.PendingUserResponse:
        return intl.pendingUserResponse;
      case TicketStatus.OnHold:
        return intl.onHold;
      case TicketStatus.GlobalIssue:
        return intl.globalIssue;

      case TicketStatus.ALL:
        return intl.all;
        break;
    }
  }

  void _scrollToEnd() {
    if (_scrollControllerStatus.hasClients) {
      _scrollControllerStatus.animateTo(
        _scrollControllerStatus.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onRetryLoadingPage() {
    ticketBloc.onRetryLoadingPage();
  }
}
