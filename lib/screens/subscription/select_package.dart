import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/screens/subscription/card_package.dart';
import 'package:behandam/screens/widget/box_end_date_subscription.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class SelectPackageSubscriptionScreen extends StatefulWidget {
  const SelectPackageSubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SelectPackageSubscriptionScreenState createState() => _SelectPackageSubscriptionScreenState();
}

class _SelectPackageSubscriptionScreenState
    extends ResourcefulState<SelectPackageSubscriptionScreen> {
  late PackageItem packageItem, packageItem2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageItem = PackageItem();
    packageItem.index = 0;
    packageItem.id = 1;
    packageItem.name = 'اشتراک سه ماهه';
    packageItem.price = Price()
      ..price = 100000
      ..finalPrice = 56000
      ..product_id = 12;
    packageItem.services = [ServicePackage()..name = 'رژیم', ServicePackage()..name = 'پشتیبانی'];
    packageItem2 = PackageItem();
    packageItem2 = PackageItem();
    packageItem2.index = 1;
    packageItem2.id = 2;
    packageItem2.name = 'اشتراک شش ماهه';
    packageItem2.price = Price()
      ..price = 130000
      ..finalPrice = 99000
      ..product_id = 13;
    packageItem2.services = [
      ServicePackage()..name = 'رژیم',
      ServicePackage()..name = 'پشتیبانی',
      ServicePackage()..name = 'برنامه ورزش'
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.selectPackageToolbar),
        body: body());
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: SizedBox(
            width: 100.w,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90.w,
                    decoration: AppDecorations.boxSmall.copyWith(
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(top: 2.h),
                    padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                    child:  BoxEndTimeSubscription(time: "121",mainAxisAlignment: MainAxisAlignment.center),
                  ),
                  Container(
                    width: 90.w,
                    decoration: AppDecorations.boxSmall.copyWith(
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(top: 1.5.h),
                    padding: EdgeInsets.only( top: 2.h),
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) =>
                            CardPackage(index == 0 ? packageItem : packageItem2,true)),
                  )
                ])),
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
