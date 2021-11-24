import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/payment.dart';
import 'package:behandam/screens/regime/payment/discount_widget.dart';
import 'package:behandam/screens/regime/payment/payment_bloc.dart';
import 'package:behandam/screens/regime/payment/payment_provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/src/extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class PaymentBillScreen extends StatefulWidget {
  const PaymentBillScreen({Key? key}) : super(key: key);

  @override
  _PaymentBillScreenState createState() => _PaymentBillScreenState();
}

class _PaymentBillScreenState extends ResourcefulState<PaymentBillScreen> {
  late PaymentBloc bloc;
  String? inputDiscountCode;
  String? messageError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = PaymentBloc();
    bloc.getPackagePayment();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      Payment? result = (event as NetworkResponse<Payment>).data;
      if ((event).next != null)
        context.vxNav.push(Uri.parse('/${(event).next}'));
      else if (bloc.isOnline) {
        Utils.launchURL(result!.url!);
      } else {
        Utils.getSnackbarMessage(context, event.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PaymentProvider(bloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.paymentFinalBill),
          body: StreamBuilder(
            stream: bloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == false) {
                return content();
              } else {
                return SpinKitCircle(
                  size: 7.w,
                  color: AppColors.primary,
                );
              }
            },
          ),
        ));
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: 80.h,
          ),
          decoration: AppDecorations.boxSmall.copyWith(
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                child: Text(
                  intl.paymentFinalBill,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Space(height: 1.h),
              _priceBox(),
              Space(height: 1.h),
              DiscountWidget(),
              Space(height: 1.h),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data == false) {
                    return Container();
                  } else
                    return _errorBox();
                },
                stream: bloc.wrongDisCode,
              ),
              Space(
                height: 3.h,
              ),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (bloc.packageItem!.price!.finalPrice! > 0)
                    return Center(
                      child: Text(
                        intl.typePaymentLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: AppColors.labelTextColor),
                      ),
                    );
                  else
                    return Container();
                },
                stream: bloc.onlineStream,
              ),
              Space(
                height: 1.h,
              ),
              StreamBuilder(
                builder: (context, snapshot) {
                  if (bloc.packageItem!.price!.finalPrice! > 0)
                    return _paymentBox();
                  else
                    return Container();
                },
                stream: bloc.onlineStream,
              ),
              StreamBuilder(
                builder: (context, snapshot) {
                  return SubmitButton(
                    onTap: () {
                      DialogUtils.showDialogProgress(context: context);
                      bloc.selectUserPayment();
                    },
                    label: bloc.packageItem!.price!.finalPrice == 0
                        ? intl.confirmContinue
                        : bloc.isOnline
                            ? intl.onlinePayment
                            : intl.cardToCardPayment,
                  );
                },
                stream: bloc.onlineStream,
              ),
              Space(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorBox() {
    return Column(
      textDirection: context.textDirectionOfLocale,
      children: <Widget>[
        SizedBox(height: 1.h),
        Row(
          textDirection: context.textDirectionOfLocaleInversed,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              messageError ?? 'sdfsf',
              textAlign: TextAlign.start,
              textDirection: context.textDirectionOfLocale,
              style: Theme.of(context).textTheme.overline!.copyWith(color: Colors.red),
            ),
            SizedBox(width: 2.w),
            ImageUtils.fromLocal(
              'assets/images/bill/alert.svg',
              fit: BoxFit.fill,
              width: 3.w,
              height: 3.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorCardGray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Space(height: 3.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 2.w,
            ),
            child: Column(
              children: <Widget>[
                _rowItems(bloc.packageItem!.price!.price.toString(), bloc.packageItem!.name!),
                Divider(),
                _rowItems(bloc.packageItem!.price!.priceDiscount.toString(), intl.discount),
                Divider(),
              ],
            ),
          ),
          Space(height: 1.h),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(252, 252, 252, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  intl.totalPayment,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                StreamBuilder(
                  builder: (context, snapshot) {
                    return Directionality(
                      textDirection: context.textDirectionOfLocale,
                      child: Text(
                        bloc.packageItem!.price!.finalPrice == 0
                            ? intl.free
                            : '${bloc.packageItem!.price!.finalPrice.toString().seRagham()} ${intl.toman}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  stream: bloc.discountLoading,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _rowItems(String price, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: context.textDirectionOfLocaleInversed,
      children: <Widget>[
        Expanded(
          child: Directionality(
            textDirection: context.textDirectionOfLocale,
            child: Text(
              price.seRagham(),
              textAlign: TextAlign.end,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Color.fromRGBO(87, 192, 159, 1)),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          flex: 2,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }

  Widget _paymentBox() {
    return Container(
      width: double.infinity,
      height: 30.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder(
            builder: (context, snapshot) {
              return paymentItemWithTick(
                  paymentItem(
                    'assets/images/bill/online.svg',
                    intl.online,
                    intl.descriptionOnline,
                    () {
                      bloc.setOnline();
                    },
                  ), () {
                bloc.setOnline();
              }, bloc.isOnline);
            },
            stream: bloc.onlineStream,
          ),
          SizedBox(width: 2.w),
          StreamBuilder(
            builder: (context, snapshot) {
              return paymentItemWithTick(
                paymentItem(
                  'assets/images/bill/credit.svg',
                  intl.cardToCard,
                  intl.descriptionCardToCard,
                  () {
                    bloc.setCardToCard();
                  },
                ),
                () {
                  bloc.setCardToCard();
                },
                bloc.isCardToCard,
              );
            },
            stream: bloc.cardToCardStream,
          ),
        ],
      ),
    );
  }

  Widget paymentItemWithTick(Widget child, Function selectPaymentType, bool tickOn) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 7.h,
            child: child,
          ),
          Positioned(
            bottom: 0.0,
            right: 15.w,
            left: 15.w,
            child: GestureDetector(
              onTap: () {
                selectPaymentType();
              },
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(239, 239, 239, 1),
                radius: 15.w,
                child: ImageUtils.fromLocal(
                  'assets/images/bill/tick.svg',
                  width: 4.w,
                  height: 4.w,
                  color: tickOn ? null : Color.fromARGB(255, 217, 217, 217),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentItem(String iconAdrs, String title, String subTitle, Function selectPaymentType) {
    return GestureDetector(
      onTap: () {
        selectPaymentType();
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromRGBO(246, 246, 246, 1),
                child: ClipPath(
                  clipper: BottomTriangle(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color.fromRGBO(239, 239, 239, 1),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: Column(
                children: <Widget>[
                  Space(height: 3.h),
                  ImageUtils.fromLocal(
                    iconAdrs,
                    fit: BoxFit.fill,
                    width: 10.w,
                    height: 10.w,
                  ),
                  Space(height: 3.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Space(height: 2.h),
                  Text(subTitle,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .overline!
                          .copyWith(color: AppColors.labelTextColor)),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
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
  void onShowMessage(String value) {
    if (bloc.isWrongDisCode)
      setState(() {
        messageError = value;
      });
  }
}
