import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/ticket/support_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State createState() => _SupportState();
}

class _SupportState extends ResourcefulState<Support> {
  late SupportBloc bloc;
  TextEditingController ticketTitleController = TextEditingController();
  TextEditingController ticketDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = SupportBloc();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.ticket,),
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: StreamBuilder<bool>(
                  stream: bloc.progressNetwork,
                  builder: (context, snapshot) {
                    if(snapshot.hasData)
                    return Container(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 4.w,
                          top: 2.h,
                          bottom: 5.h,
                        ),
                        height: 100.h,
                        width: double.maxFinite,
                        child: Column(
                            textDirection: context.textDirectionOfLocale,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Space(
                                height: 2.h,
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                                child: ImageUtils.fromLocal("assets/images/ticket/img.jpg",
                                    width: 30.w, height: 30.w, isCircle: true),
                              ),
                              Space(
                                height: 2.h,
                              ),
                              Text(
                                intl.supporter,
                                style: typography.caption!.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Space(
                                height: 1.h,
                              ),
                              Text(
                                intl.callWithSupport,
                                style: typography.caption,
                              ),
                              Space(
                                height: 4.h,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  IntentUtils.launchURL(bloc.linkWhatsApp ?? "http://wa.me/96170068776");
                                },
                                label: Text(
                                  intl.whatsApp,
                                  style: typography.button,
                                ),
                                icon: const Icon(Icons.whatsapp),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(AppColors.accentColor)),
                              ),
                            ]));
                    else return Progress();
                  }
                )),
            BottomNav(currentTab: BottomNavItem.SUPPORT),
          ],
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
