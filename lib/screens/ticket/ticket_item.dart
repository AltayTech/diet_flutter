import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/screens/ticket/ticket_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class TicketItemWidget extends StatefulWidget {
  late TicketItem ticketItem;

  TicketItemWidget({required this.ticketItem});

  @override
  State createState() => TicketItemWidgetState();
}

class TicketItemWidgetState extends ResourcefulState<TicketItemWidget> {
  late TicketBloc ticketBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ticketBloc = TicketProvider.of(context);
    return ticketItems();
  }

  Widget ticketItems() {
    return GestureDetector(
      onTap: () async {
        if (widget.ticketItem.status == TicketStatus.GlobalIssue) {
          DialogUtils.showDialogPage(
              context: context,
              isDismissible: true,
              child: Container(
                width: 80.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
//              mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 3.h),
                    Text(
                      intl.closedTicket,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          child: Text(
                            intl.ok,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 2.w),
                        MaterialButton(
                          child: Text(
                            intl.cancel,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => VxNavigator.of(context).pop(),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ));
          /* if (showOpenDialog)
            Navigator.of(context).pushNamed(
              TicketDetails.routeName,
              arguments: {
                'ticketId': int.parse(message['id'].toString()),
                'ticketTitle': message['title'],
              },
            );*/
        } else {
        //  print('after dialog');
/*
queryParameters:{
              'ticketId': widget.ticketItem.id,
              'ticketTitle': widget.ticketItem.title,
            } */

          try {
            Uri uri = Uri(path: '${Routes.detailsTicketMessage}', queryParameters: {
              'ticketId': widget.ticketItem.id.toString(),
            });
            context.vxNav.push(uri);
          }catch (e){
            print('uri = > ${e.toString()} ');
          }
          //uri.replace();


        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.onPrimary,
        ),
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          textDirection: context.textDirectionOfLocale,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.ticketItem.title!,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption,
            ),
            Divider(
              color: Colors.grey[200],
              thickness: 0.3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 4.h,
                  width: 1.w,
                  color: ticketBloc.statusColor(widget.ticketItem.status!),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    ticketBloc.findTicketStatus(widget.ticketItem.status!),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: ticketBloc.statusColor(widget.ticketItem.status!),
                        ),
                  ),
                ),
                SizedBox(width: 2.w),
                ImageUtils.fromLocal(
                  'assets/images/foodlist/archive.svg',
                  width: 6.w,
                  height: 6.w,
                  fit: BoxFit.fill,
                  color: AppColors.primary,
                ),
                SizedBox(width: 2.w),
                Text(
                  DateTimeUtils.gregorianToJalali(widget.ticketItem.createdAt!),
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ],
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
}
