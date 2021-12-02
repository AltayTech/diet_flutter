import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/screens/shop/category_bloc.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({Key? key}) : super(key: key);

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends ResourcefulState<MyProductPage> {
  late CategoryBloc categoryBloc;

  @override
  void initState() {
    super.initState();
    categoryBloc = CategoryBloc();
    listenBloc();
  }

  void listenBloc() {
    categoryBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child: Scaffold(
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
            ImageUtils.fromLocal('assets/images/shop/title.png'),
            SizedBox(height: 2.h),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: categoryBloc.category,
                builder: (context,snapshot){
                  return SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: 1,
                        itemBuilder: (_, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              children: [
                                firstTile(),
                              ],
                            ),
                          );
                        }
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget firstTile(){
    return Padding(
      padding: const EdgeInsets.only(top: 12.0,bottom: 12.0),
      child: ListTile(
        leading: ImageUtils.fromLocal('assets/images/shop/shape.png',width: 25.w,height: 20.h),
        title: Text(intl.login),
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
