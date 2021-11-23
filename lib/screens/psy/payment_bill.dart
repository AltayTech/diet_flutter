import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/line.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentBillScreen extends StatefulWidget {
  const PaymentBillScreen({Key? key}) : super(key: key);

  @override
  _PaymentBillScreenState createState() => _PaymentBillScreenState();
}

class _PaymentBillScreenState extends ResourcefulState<PaymentBillScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.redBar,
        title: Text(intl.condition),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                 Text(intl.attention,style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 2.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.grey
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(''),
                              Text(''),
                            ],
                          ),
                          line(),
                          Row(
                            children: [
                              Text(''),
                              Text(''),
                            ],
                          ),
                          line(),
                          Row(
                            children: [
                              Text(''),
                              Text(''),
                            ],
                          ),
                          line(),
                          Row(
                            children: [
                              Text(''),
                              Text(''),
                            ],
                          ),
                          line(),
                          Row(
                            children: [
                              Text(''),
                              Text(''),
                            ],
                          ),
                          line(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white
                            ),
                            child: Column(
                              children: [
                                Text(''),
                                Text(''),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  button(AppColors.primaryVariantLight, intl.readRules, Size(70.w,5.h), (){}),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
  Widget line(){
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
      child: Line(color: AppColors.strongPen,height: 0.1.h),
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
