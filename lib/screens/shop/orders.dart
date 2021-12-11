import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/screens/shop/orders_bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
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
    ordersBloc.getOrders();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.myProduct),
        leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: ordersBloc.orders,
                builder: (context,
                    AsyncSnapshot<List<ShopProduct>> snapshot) {
                  if (snapshot.hasData)
                    return Column(
                      children: [
                        ...snapshot.data!
                            .map((order) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Column(
                                    children: [
                                      firstTile(order.productName,
                                          order.productThambnail),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       right: 12.0, left: 12.0),
                                      //   child: Line(
                                      //       color: AppColors.strongPen, height: 0.1.h),
                                      // ),
                                      // secondTile(order.sellingPrice,order.discountPrice),
                                      Text(
                                        ordersBloc.count.toString(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.redBar),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    );
                  else
                    return Progress();
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget firstTile(String? name, String? pic) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: ListTile(
        leading: pic == null
            ? ImageUtils.fromLocal(
                'assets/images/shop/shape.png',
                width: 20.w,
                height: 10.h,
              )
            : ImageUtils.fromNetwork(
                FlavorConfig.instance.variables["baseUrlFile"] + pic,
                width: 20.w,
                height: 10.h,
              ),
        title: Text(name ?? '--'),
      ),
    );
  }

  Widget secondTile(int? selling, int? discount) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(selling.toString(),
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 10.sp)),
              Text(discount.toString() + intl.currency,
                  style: TextStyle(fontSize: 12.sp))
            ],
          ),
          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(45.w, 6.h)),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(AppColors.redBar),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
                side: MaterialStateProperty.all(
                    BorderSide(color: AppColors.redBar))),
            child: Row(
              children: [
                ImageUtils.fromLocal('assets/images/shop/add_cart.svg',
                    width: 2.w, height: 3.h),
                SizedBox(width: 2.w),
                Text(intl.buyThisCourse,
                    style: TextStyle(color: AppColors.redBar, fontSize: 14.sp)),
              ],
            ),
          ),
        ],
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
