import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/utils/card_formatter.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:share_plus/share_plus.dart';

class CardOwnerBoxWidget extends StatefulWidget {
  const CardOwnerBoxWidget({Key? key}) : super(key: key);

  @override
  State<CardOwnerBoxWidget> createState() => _CardOwnerBoxWidgetState();
}

class _CardOwnerBoxWidgetState extends ResourcefulState<CardOwnerBoxWidget> {
  late PaymentBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = PaymentProvider.of(context);

    return cardOwnerBox();
  }

  Widget cardOwnerBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            intl.paymentCardToCard,
            style: typography.subtitle2?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
            softWrap: true,
          ),
        ),
        Text(
          intl.cardToCardDescription,
          style: typography.caption
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
          textAlign: TextAlign.start,
          softWrap: true,
        ),
        Container(
          width: 100.w,
          child: Stack(
            children: [
              ImageUtils.fromLocal('assets/images/bill/card.svg', fit: BoxFit.fill,),
              Positioned(
                child: Text(
                  bloc.invoice?.name ?? intl.unknown,
                  style: typography.button?.copyWith(
                    color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
                right: 10.w,
                top: 5.5.h,
              ),
              Positioned(
                child: Text(
                  CardNumberInputFormatter.getFormatString(bloc.invoice?.cardNumber ?? '62190000') ,
                  style: typography.headline5?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  softWrap: true,
                ),
                right: 10.w,
                left: 10.w,
                top: 13.h,
              ),
              Positioned(
                child: Text(
                  bloc.invoice?.ownerName ?? intl.unknown,
                  style: typography.bodyText1?.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
                right: 11.w,
                left: 11.w,
                top: 18.h,
              )
            ],
          ),
        ),
        copyShareBox(bloc.invoice!),
      ],
    );
  }

  Widget copyShareBox(LatestInvoiceData latestInvoiceData) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: copyShareItem('assets/images/bill/copy.svg', intl.copyCardNumber, () {
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 1,
            color: Colors.red,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 0,
              child: ImageUtils.fromLocal(
                iconPath,
                width: 4.w,
                height: 2.h,
              ),
            ),
            Space(width: 2.w),
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: typography.caption!
                    .copyWith(color: Colors.red, fontSize: 10.sp, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
