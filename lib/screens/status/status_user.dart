import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/status/bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatusUserScreen extends StatefulWidget {
  const StatusUserScreen({Key? key}) : super(key: key);

  @override
  _StatusUserScreenState createState() => _StatusUserScreenState();
}

class _StatusUserScreenState extends ResourcefulState<StatusUserScreen> {
  late StatusBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = StatusBloc();
    bloc.getVisitUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.statusBodyTermUser),
      body: Container(
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            content(),
            Positioned(
              bottom: 0,
              child: BottomNav(
                currentTab: BottomNavItem.STATUS,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: SingleChildScrollView(
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false) {
              return Container(
                constraints: BoxConstraints(minHeight: 80.h, minWidth: 100.w),
                color: Color.fromRGBO(245, 245, 245, 1),
                padding: EdgeInsets.fromLTRB(
                  4.w,
                  3.h,
                  4.w,
                  6.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: context.textDirectionOfLocale,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        children: [
                          itemUi('سال', '??', 'سن'),
                          SizedBox(height: 1.h),
                          itemUi('سانتی متر', '??', 'قد'),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', 0.toString(), 'وزن اولیه'),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', 0.toString(), 0 > 0 ? 'وزن اضافه شده' : 'وزن کم شده'),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', '??', 'وزن باقیمانده'),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', 0.toString(), "وزن مناسب هنگام زایمان"),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', '', "وزن مناسب آخرین مراجعه"),
                          SizedBox(height: 1.h),
                          itemUi('کیلوگرم', 0.toString(), "تعداد روز باقیمانده تا وضع حمل"),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else
              return Center(
                child: SpinKitCircle(
                  color: AppColors.primary,
                  size: 7.w,
                ),
              );
          },
          stream: bloc.waiting,
        ),
      ),
    );
  }

  Widget itemUi(String unit, String? amount, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(241, 241, 241, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        textDirection: context.textDirectionOfLocaleInversed,
        children: [
          Text(
            unit,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(width: 1.w),
          Text(
            amount ?? '??',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.caption,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  void onShowMessage(String value) {}
}
