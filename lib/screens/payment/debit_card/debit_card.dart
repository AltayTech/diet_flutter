import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/debit_card/card_info.dart';
import 'package:behandam/screens/payment/debit_card/card_owner_box.dart';
import 'package:behandam/screens/payment/debit_card/payment_date.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class DebitCardPage extends StatefulWidget {
  const DebitCardPage({Key? key}) : super(key: key);

  @override
  State<DebitCardPage> createState() => _DebitCardPageState();
}

class _DebitCardPageState extends ResourcefulState<DebitCardPage> {
  late PaymentBloc bloc;
  bool showUserInfo = false;
  late LatestInvoiceData invoice;
  TextEditingController nameController = TextEditingController();
  late TextEditingController cardController;

  @override
  void initState() {
    super.initState();
    cardController = TextEditingController();
    invoice = LatestInvoiceData();
    nameController.text = invoice.cardOwner ?? '';
    cardController.text = invoice.cardNum ?? '';
    bloc = PaymentBloc();
    bloc.getLastInvoice();
    invoice.cardOwner = MemoryApp.userInformation?.fullName;
    invoice.payedAt = DateTime.now().toString().substring(0, 10);
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).clearAndPush(Uri.parse('/$event'));
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    cardController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PaymentProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.paymentCardToCard),
        body: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: StreamBuilder(
        stream: bloc.waiting,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && !snapshot.data!) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardOwnerBoxWidget(),
                  Space(height: 4.h),
                  CardInfoWidget(),
                  Space(height: 2.h),
                  PaymentDateWidget(),
                  Space(height: 2.h),
                  registerPaymentInfo()
                ]);
          }
          return Center(child: Progress());
        },
      ),
    );
  }

  Widget registerPaymentInfo() {
    return Center(
      child: SubmitButton(
        label: intl.submitOfflinePayment,
        onTap: () {
          showUserInfo
              ? (invoice.cardOwner.isNullOrEmpty ||
              invoice.cardNum.isNullOrEmpty ||
              invoice.payedAt.isNullOrEmpty)
              ? null
              : bloc.newPayment(invoice)
              : setState(() {
            showUserInfo = true;
          });
          ;
        },
        size: Size(80.w, 6.h),
      ),
    );
  }

  Widget cardNumber(String cardNumber) {
    var exp = RegExp('([0-9]{4}|[,!.?\s ])');
    var matches = exp.allMatches(cardNumber);
    final List<String> numberArray = [];
    for (var m in matches) {
      numberArray.add(m.group(0) ?? '');
    }
    return Row(
      children: [
        numberBox(numberArray[3]),
        numberBox(numberArray[2]),
        numberBox(numberArray[1]),
        numberBox(numberArray[0]),
      ],
    );
  }

  Widget numberBox(String text) {
    return Expanded(
      flex: 1,
      child: Card(
        shape: AppShapes.rectangleVerySmall,
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Text(
            text,
            style: typography.caption,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    return Column(
      children: [
        Space(height: 2.h),
        textInput(
          height: 8.h,
          textInputType: TextInputType.text,
          validation: (val) {},
          onChanged: (val) => invoice.cardOwner = val,
          value: invoice.cardOwner,
          label: intl.accountOwnerName,
          maxLine: false,
          enable: true,
          ctx: context,
          action: TextInputAction.next,
          formatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
          ],
          textDirection: context.textDirectionOfLocale,
          // textController: nameController,
        ),
        warning(intl.nameOfWhoPayed),
        Space(height: 3.h),
        textInput(
          height: 8.h,
          textInputType: TextInputType.number,
          validation: (val) {},
          onChanged: (val) => invoice.cardNum = val,
          value: invoice.cardNum,
          label: intl.fourLastNumberOfCard,
          maxLine: false,
          ctx: context,
          enable: true,
          action: TextInputAction.done,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            LengthLimitingTextInputFormatter(4),
          ],
          textDirection: context.textDirectionOfLocale,
          endCursorPosition: true,
          // textController: cardController,
        ),
        warning(intl.fourLastCardNumberOfWhoPayed),
        Space(height: 2.h),
        Text(
          intl.paymentDate,
          style: typography.caption?.apply(color: AppColors.labelColor),
          textAlign: TextAlign.center,
        ),
        Space(height: 1.h),
        dateBox(),
      ],
    );
  }

  Widget warning(String text) {
    return Row(
      children: [
        ImageUtils.fromLocal(
          'assets/images/foodlist/advice/bulb.svg',
          width: 5.w,
          height: 5.w,
          color: AppColors.warning,
        ),
        Space(width: 2.w),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            softWrap: true,
            style: typography.caption,
          ),
        ),
      ],
    );
  }

  Widget dateBox() {
    return InkWell(
      child: ClipRRect(
        borderRadius: AppBorderRadius.borderRadiusDefault,
        child: Container(
          width: double.infinity,
          height: 7.h,
          color: AppColors.grey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 12.w,
                height: double.infinity,
                color: AppColors.strongPen,
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                dateFormatted() ?? '',
                style: typography.subtitle2,
              ),
            ],
          ),
        ),
      ),
      onTap: _selectDate,
    );
  }

  String? dateFormatted() {
    if (!invoice.payedAt.isNullOrEmpty) {
      var formatter =
          Jalali.fromDateTime(DateTime.parse(invoice.payedAt!)).formatter;
      return '${formatter.d} ${formatter.mN} ${formatter.yyyy}';
    }
    return null;
  }

  Future _selectDate() async {
    DialogUtils.showBottomSheetPage(
        context: context,
        child: TouchMouseScrollable(
          child: SingleChildScrollView(
              child: Container(
            height: 32.h,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.center,
            child: Center(
              child: CustomDate(
                function: (value) {
                  print('value = > $value');
                  setState(() {
                    invoice.payedAt = value!;
                  });
                },
                datetime: invoice.payedAt,
                maxYear: Jalali.now().year,
              ),
            ),
          )),
        ));
  }

  // Future _selectDate() async {
  //   Jalali? picked = await showPersianDatePicker(
  //     context: context,
  //     initialDate: Jalali.now(),
  //     firstDate: Jalali(1200, 8),
  //     lastDate: Jalali(1450, 9),
  //   );
  //   setState(() {
  //     invoice.payedAt = picked!.toGregorian().toDateTime().toString().substring(0, 10);
  //     debugPrint('birthdate $picked / ${invoice.payedAt}');
  //   });
  // }

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
