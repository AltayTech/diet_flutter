import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/shop/orders_bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends ResourcefulState<OrdersPage> {
  late OrdersBloc ordersBloc;

  @override
  void initState() {
    super.initState();
    ordersBloc = OrdersBloc();
    ordersBloc.getOrders();
    listenBloc();
  }

  void listenBloc() {
    ordersBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(
    titleBar: intl.myProduct,
      ),
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: TouchMouseScrollable(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder(
                  stream: ordersBloc.orders,
                  builder: (context, AsyncSnapshot<List<ShopProduct>> snapshot) {
                    if (snapshot.hasData) if (snapshot.requireData.length > 0) {
                      return Column(
                        children: [
                          ...snapshot.data!
                              .map((order) => Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [firstTile(order), secondTile(order)],
                                    ),
                                  ))
                              .toList(),
                        ],
                      );
                    } else {
                      return SizedBox(
                          height: 80.h,
                          child: Center(
                              child: EmptyBox(
                            child: Text(
                              intl.emptyProduct,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: AppColors.labelTextColor),
                            ),
                            predicate: false,
                          )));
                    }
                    else
                      return Container(height: 80.h, child: Progress());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget firstTile(ShopProduct product) {
    return Padding(
      padding: EdgeInsets.only(top: 2.w, bottom: 2.w, left: 2.w, right: 2.w),
      child: Container(
        height: 10.h,
        child: Row(
          textDirection: context.textDirectionOfLocale,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: ImageUtils.fromNetwork(Utils.getCompletePathShop(product.productThambnail),
                    width: 20.w,
                    height: 9.h,
                    fit: BoxFit.fill)),
            Space(
              width: 3.w,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.productName!,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget secondTile(ShopProduct product) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () =>
                  VxNavigator.of(context).push(Uri.parse('${Routes.shopProduct}/${product.id!}')),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(AppColors.primary),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  side: MaterialStateProperty.all(BorderSide(color: AppColors.primary))),
              child: Text(intl.view, style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  @override
  void onRetryLoadingPage() {
    ordersBloc.setRepository();
    ordersBloc.getOrders();
  }
}
