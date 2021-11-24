// import 'package:behandam/screens/utility/pay_diamond.dart';
// import 'package:behandam/utils/image.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
//  class PaymentCardScreen extends StatefulWidget {
//    const PaymentCardScreen({Key? key}) : super(key: key);
//
//    @override
//    _PaymentCardScreenState createState() => _PaymentCardScreenState();
//  }
//
//  class _PaymentCardScreenState extends State<PaymentCardScreen> {
//    @override
//    Widget build(BuildContext context) {
//      return SafeArea(child: Scaffold(
//        body: SingleChildScrollView(
//          child: Container(
//            child: Column(
//              children: [
//                Stack(
//                  children: <Widget>[
//                    Container(
//                      height: 10.h,
//                    ),
//                    Positioned(
//                      top: 0,
//                      bottom: 0,
//                      right: 0,
//                      left: 0,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(10),
//                        child: Container(
//                          color: Color.fromARGB(255, 255, 231, 231),
//                          child: Container(
//                            child: ClipPath(
//                              clipper: PayDiamond(),
//                              child: Container(
//                                color: Theme.of(context).primaryColor,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    Positioned(
//                      top: 0,
//                      bottom: 0,
//                      left: ( 100) * 3,
//                      right: 0.2,
//                      child: Center(
//                        child: RichText(
//                          textDirection: TextDirection.rtl,
//                          text: TextSpan(
//                            style: TextStyle(
//                              color: Theme.of(context).primaryColor,
//                              fontSize: 12.sp,
//                              fontFamily: 'IRANSans',
//                            ),
//                            children: <TextSpan>[
//                              TextSpan(text: 'مبلغ '),
//                              // TextSpan(
//                              //   text:
//                              //   '${double.parse(paymentInfo['amount'].toString()).toStringAsFixed(0).seRagham()} تومان ',
//                              //   style: TextStyle(
//                              //     fontWeight: FontWeight.bold,
//                              //     fontFamily: 'IRANSans',
//                              //   ),
//                              // ),
//                              TextSpan(
//                                  text:
//                                  'از طریق عابر بانک یا اپ های بانکی به شماره کارت زیر واریز کنید.'),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                    Positioned(
//                      right: 10,
//                      top: 10,
//                      bottom: 10,
//                      child: Center(
//                        child: ImageUtils.fromLocal(
//                          'assets/images/bill/idea.svg',
//                          fit: BoxFit.cover,
//                          width: 2.w,
//                          height: 2.h,
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      ));
//    }
//  }
