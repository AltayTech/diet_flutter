import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/subscription/card_package.dart';
import 'package:behandam/screens/subscription/select_package/bloc.dart';
import 'package:behandam/screens/subscription/select_package/provider.dart';
import 'package:behandam/screens/widget/box_end_date_subscription.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class SelectPackageSubscriptionScreen extends StatefulWidget {
  const SelectPackageSubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SelectPackageSubscriptionScreenState createState() =>
      _SelectPackageSubscriptionScreenState();
}

class _SelectPackageSubscriptionScreenState
    extends ResourcefulState<SelectPackageSubscriptionScreen> {
  late SelectPackageSubscriptionBloc bloc;

  late PackageItem packageItem, packageItem2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = SelectPackageSubscriptionBloc();
    bloc.getPackageSubscriptionList();

    packageItem = PackageItem();
    packageItem.index = 0;
    packageItem.id = 1;
    packageItem.name = 'اشتراک سه ماهه';
    packageItem.price = PackagePrice()
      ..amount = 100000
      ..saleAmount = 56000
      ..priceableId = 12;
    packageItem.services = [
      ServicePackage()..name = 'رژیم',
      ServicePackage()..name = 'پشتیبانی'
    ];
    packageItem2 = PackageItem();
    packageItem2 = PackageItem();
    packageItem2.index = 1;
    packageItem2.id = 2;
    packageItem2.name = 'اشتراک شش ماهه';
    packageItem2.price = PackagePrice()
      ..amount = 130000
      ..saleAmount = 99000
      ..priceableId = 13;
    packageItem2.services = [
      ServicePackage()..name = 'رژیم',
      ServicePackage()..name = 'پشتیبانی',
      ServicePackage()..name = 'برنامه ورزش'
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SelectPackageSubscriptionProvider(bloc,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: Toolbar(titleBar: intl.reviveSubscription),
            body: body()));
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
                    padding: EdgeInsets.only(
                        left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                    child: BoxEndTimeSubscription(
                        time:
                            '${MemoryApp.termPackage!.subscriptionTermData!.currentSubscriptionRemainingDays!}',
                        mainAxisAlignment: MainAxisAlignment.center),
                  ),
                  Container(
                    width: 90.w,
                    decoration: AppDecorations.boxSmall.copyWith(
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(top: 1.5.h),
                    padding: EdgeInsets.only(top: 2.h),
                    child: StreamBuilder<bool>(
                        stream: bloc.progressNetwork,
                        builder: (context, progressNetwork) {
                          if (progressNetwork.hasData &&
                              !progressNetwork.requireData)
                            return bloc.packageList != null &&
                                    bloc.packageList!.length > 0
                                ? ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: bloc.packageList!.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        CardPackage(bloc.packageList![index]))
                                : Container(
                                    height: 20.h,
                                    child: Center(
                                        child: Text(
                                            intl.subscriptionPackageNotAvailable,
                                            style: typography.caption)),
                                  );

                          return Progress();
                        }),
                  )
                ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
    bloc.getPackageSubscriptionList();
  }
}
