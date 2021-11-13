import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_item.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class Ticket extends StatefulWidget {
  Ticket() {}

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends ResourcefulState<Ticket> {
  bool showOpenDialog = false;

  late TicketBloc ticketBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticketBloc = TicketBloc();
    ticketBloc.getTickets();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TicketProvider(ticketBloc,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          body: SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 245, 245, 245),
              padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
                top: 2.h,
                bottom: 5.h,
              ),
              child: Column(
                textDirection: context.textDirectionOfLocale,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 245),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 3.h),
                        GestureDetector(
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
                  StreamBuilder(
                    builder: (context, snapshot) {
                      if(snapshot.data!=null && snapshot.data==false){
                        return Container(
                          child: Column(
                            children: [
                              ...ticketBloc.listTickets
                                  .map((message) => TicketItemWidget(
                                ticketItem: message,
                              ))
                                  .toList()
                            ],
                          ),
                        );
                      }else {
                        return Center(child: SpinKitCircle(
                          size: 5.h,
                          color: AppColors.primary,
                        ),);
                      }
                    },
                    stream: ticketBloc.progressNetwork,
                  )
                ],
              ),
            ),
          ),
        ));
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
