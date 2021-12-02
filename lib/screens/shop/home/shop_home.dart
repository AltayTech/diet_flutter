import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/home/bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/slider_app.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({Key? key}) : super(key: key);

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends ResourcefulState<ShopHomeScreen> {
  late ShopHomeBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ShopHomeBloc();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {});
    bloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.redBar,
          title: Text(intl.behandam, textAlign: TextAlign.center)),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data==false)
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (bloc.list[index].styleType == StyleType.slider)
                  return SliderApp(banners: bloc.list[index].items!);
                else
                  return Container();
              },
              shrinkWrap: true,
              itemCount: bloc.list.length,
            ),
          );
          else return Progress();
        },
        stream: bloc.loadingContent,
      ),
      bottomNavigationBar: BottomNav(
        currentTab: BottomNavItem.VITRINE,
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
