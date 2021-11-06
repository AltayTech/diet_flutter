import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum ticketStatus {
  Resolved,
  Closed,
  PendingAdminResponse,
  PendingUserResponse,
  OnHold,
  GlobalIssue
}

class Ticket extends StatefulWidget {
  Ticket() {}

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends ResourcefulState<Ticket> {
  String? _findTicketStatus(int status) {
    switch (status) {
      case 0:
        return 'در انتظار پاسخ';
      case 1:
        return 'پیام جدید';
      case 2:
        return 'در حال بررسی';
      case 3:
        return 'مشکل سراسری';
      case 4:
        return 'حل شده';
      case 5:
        return 'بسته شده';
    }
    return null;
  }

  Color? _statusColor(int status) {
    switch (status) {
      case 0:
        return Color.fromRGBO(235, 197, 69, 1);
      case 1:
        return Theme.of(context).primaryColorLight;
      case 2:
        return Colors.lightBlue;
      case 3:
        return Colors.pinkAccent;
      case 4:
        return Colors.grey[700];
    }
    return null;
  }


  late TicketBloc ticketBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticketBloc=TicketBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 245, 245, 245),
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 3.h,
            bottom: 6.h,
          ),
          child: Column(
            textDirection: context.textDirectionOfLocale,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal:4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 3.h),
                      GestureDetector(
                       // onTap: () => Navigator.of(context).pushNamed(NewTicket.routeName),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.w,
                              vertical: 1.h),
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
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: ImageUtils.fromLocal(
                                  'assets/images/ticket/new_ticket.svg',
                                  width: 7.w,
                                  height: 7.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 3.h),

                  ],
                ),
              ),
              StreamBuilder(builder: (context, snapshot) {
                return Container();
              },stream: ticketBloc.progressNetwork,)
            ],
          ),
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
}
