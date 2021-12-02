import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/screens/shop/category_bloc.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends ResourcefulState<CategoryPage> {
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
        title: Text(intl.shop),
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
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 12.0, left: 12.0),
                                child: Line(
                                    color: AppColors.strongPen, height: 0.1.h),
                              ),
                              secondTile(),
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

  Widget secondTile(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
           children: [
             Text('\25.000', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey,fontSize: 10.sp)),
             Text('\24.900 ${intl.currency}', style: TextStyle(fontSize: 12.sp))
           ],
         ),
          OutlinedButton(
            onPressed: () {},
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(45.w,6.h)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(AppColors.redBar),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              side: MaterialStateProperty.all(BorderSide(color: AppColors.redBar))
            ),
            child: Row(
              children: [
                ImageUtils.fromLocal('assets/images/shop/add_cart.svg',width: 2.w,height: 3.h),
                SizedBox(width: 2.w),
                Text(intl.buyThisCourse,style: TextStyle(color: AppColors.redBar,
                    fontSize: 14.sp)),
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
