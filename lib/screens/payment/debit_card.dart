import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
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
import 'package:behandam/extensions/string.dart';

class DebitCardPage extends StatefulWidget {
  const DebitCardPage({Key? key}) : super(key: key);

  @override
  State<DebitCardPage> createState() => _DebitCardPageState();
}

class _DebitCardPageState extends ResourcefulState<DebitCardPage> {
  late PaymentBloc bloc;
  bool showUserInfo = false;
  // String? username, fourLastNumberOfCard, paymentDate;
  late LatestInvoiceData invoice;

  @override
  void initState() {
    super.initState();
    invoice = LatestInvoiceData();
    bloc = PaymentBloc();
    bloc.latestInvoiceLoad();
    invoice.ownerName = MemoryApp.userInformation?.fullName;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.paymentCardToCard),
      body: SingleChildScrollView(
        child: cardOwnerBox(),
      ),
    );
  }

  Widget cardOwnerBox() {
    return Card(
      shape: AppShapes.rectangleMedium,
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: StreamBuilder(
          stream: bloc.latestInvoice,
          builder: (_, AsyncSnapshot<LatestInvoiceData> snapshot) {
            if (snapshot.hasData) {

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  amountDescription(snapshot.requireData),
                  Space(height: 2.h),
                  Container(
                    decoration: AppDecorations.boxMild.copyWith(
                      color: AppColors.box,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: Column(
                      children: [
                        cardNumber(snapshot.requireData.cardNumber!),
                        Space(height: 2.h),
                        Text(
                          intl.inNameOf(snapshot.requireData.ownerName!),
                          style: typography.subtitle2?.apply(
                            color: AppColors.primary,
                            fontWeightDelta: 3,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                        Space(height: 2.h),
                        copyShareBox(snapshot.requireData),
                      ],
                    ),
                  ),
                  Space(height: 2.h),
                  Text(
                    showUserInfo
                        ? intl.nowFillFollowingInformation
                        : intl.clickFollowingButtonAfterPayment,
                    style: typography.subtitle2
                        ?.apply(color: AppColors.labelColor),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  if (showUserInfo) userInfo(),
                  Space(height: 2.h),
                  Center(
                    child: SubmitButton(
                      label: showUserInfo
                          ? intl.submitOfflinePayment
                          : intl.deposited,
                      onTap: showUserInfo
                          ? (invoice.ownerName.isNullOrEmpty ||
                                  invoice.cardNumber.isNullOrEmpty ||
                                  invoice.payedAt.isNullOrEmpty)
                              ? null
                              : () {
                                  bloc.newPayment(invoice);
                                }
                          : () {
                              setState(() {
                                showUserInfo = true;
                              });
                            },
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget amountDescription(LatestInvoiceData data) {
    return Container(
      decoration: AppDecorations.boxMild.copyWith(
        color: AppColors.primary.withOpacity(0.3),
      ),
      height: 10.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: AppDecorations.boxMild.copyWith(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomRight: AppRadius.radiusMild,
                topRight: AppRadius.radiusMild,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: ImageUtils.fromLocal(
              'assets/images/bill/idea.svg',
              width: 8.w,
              height: 8.w,
            ),
          ),
          Space(width: 2.w),
          Expanded(
            child: Center(
              child: Text(
                intl.depositTheAmount(data.amount!.toInt().toString()),
                style: typography.caption?.apply(
                  color: AppColors.primary,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
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

  Widget copyShareBox(LatestInvoiceData latestInvoiceData) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: copyShareItem('assets/images/bill/copy.svg', intl.copy, () {
            Clipboard.setData(ClipboardData(
              text: intl.debitCardInfo(
                latestInvoiceData.cardNumber!,
                latestInvoiceData.ownerName!,
                latestInvoiceData.amount!.toInt().toString(),
              ),
            ));
            Utils.getSnackbarMessage(context, intl.copied);
          }),
        ),
        Space(width: 3.w),
        Expanded(
          flex: 1,
          child: copyShareItem('assets/images/bill/share.svg', intl.share, () {
            Share.share(
                intl.debitCardInfo(
                  latestInvoiceData.cardNumber!,
                  latestInvoiceData.ownerName!,
                  latestInvoiceData.amount!.toInt().toString(),
                ),
                subject: 'شماره کارت');
          }),
        ),
      ],
    );
  }

  Widget copyShareItem(String iconPath, String title, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: AppDecorations.boxMedium.copyWith(
          color: AppColors.labelColor.withOpacity(0.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.7.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtils.fromLocal(
              iconPath,
              width: 7.w,
              height: 7.w,
            ),
            Space(width: 2.w),
            Text(
              title,
              style: typography.caption,
              textAlign: TextAlign.center,
            ),
          ],
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
          onChanged: (val) => setState(() => invoice.ownerName = val),
          value: invoice.ownerName,
          label: intl.accountOwnerName,
          maxLine: false,
          enable: true,
          ctx: context,
          action: TextInputAction.next,
          formatter: FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
          textDirection: context.textDirectionOfLocale,
        ),
        warning(intl.nameOfWhoPayed),
        Space(height: 3.h),
        textInput(
          height: 8.h,
          textInputType: TextInputType.text,
          validation: (val) {},
          onChanged: (val) => setState(() => invoice.cardNumber = val),
          value: invoice.cardNumber,
          label: intl.fourLastNumberOfCard,
          maxLine: false,
          ctx: context,
          enable: true,
          action: TextInputAction.next,
          formatter: null,
          textDirection: context.textDirectionOfLocale,
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
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1200, 8),
      lastDate: Jalali(1450, 9),
    );
    setState(() {
      invoice.payedAt =
          picked!.toGregorian().toDateTime().toString().substring(0, 10);
      debugPrint('birthdate $picked / ${invoice.payedAt}');
    });
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
