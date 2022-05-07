import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:velocity_x/velocity_x.dart';

class CardPackage extends StatefulWidget {
  PackageItem packageItem;
  bool isSelected;

  CardPackage(this.packageItem, this.isSelected);

  @override
  _CardPackageState createState() => _CardPackageState();
}

class _CardPackageState extends ResourcefulState<CardPackage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _card(widget.packageItem);
  }

  Widget _card(PackageItem pack) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h, left: 4.w, right: 4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () {
            if (widget.isSelected)
              DialogUtils.showBottomSheetPage(context: context, child: bottomSheet());
          },
          child: Container(
            padding: EdgeInsets.only(right: 3.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: pack.barColor,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                color: Color.fromARGB(255, 240, 239, 238),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: context.textDirectionOfLocaleInversed,
                    children: <Widget>[
                      Expanded(
                          flex: 0,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: ImageUtils.fromLocal(
                                  'assets/images/diet/diet.svg',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                              Space(height: 1.h),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            textDirection: context.textDirectionOfLocaleInversed,
                            children: <Widget>[
                              Text(
                                pack.name ?? '',
                                textAlign: TextAlign.start,
                                softWrap: true,
                                maxLines: 2,
                                textDirection: context.textDirectionOfLocale,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(letterSpacing: -0.2, fontSize: 12.sp),
                              ),
                              if (pack.services != null && pack.services!.length > 0)
                                ...pack.services!.map(
                                    (product) => _itemOption(product.name ?? '', pack.barColor)),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.only(
                      left: 2.w,
                      right: 2.w,
                      top: 2.w,
                      bottom: 2.w,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: context.textDirectionOfLocaleInversed,
                            children: [
                              if (pack.price?.finalPrice != null &&
                                  pack.price?.finalPrice != pack.price?.price)
                                Directionality(
                                  textDirection: context.textDirectionOfLocale,
                                  child: Text(
                                    pack.price?.finalPrice != null &&
                                            int.parse(pack.price!.finalPrice.toString()) != 0
                                        ? '${int.parse(pack.price!.finalPrice.toString()).toString().seRagham()} ${intl.toman}'
                                        : intl.free,
                                    // '${int.parse(pack['price']['final_price'].toString())} تومان',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption!.copyWith(
                                          color: pack.priceColor,
                                        ),
                                  ),
                                ),
                              if (pack.price!.finalPrice != null)
                                Expanded(
                                  child: Space(),
                                  flex: 1,
                                ),
                              if (pack.price?.price != null)
                                Directionality(
                                  textDirection: context.textDirectionOfLocale,
                                  child: Text(
                                    pack.price?.price != null
                                        ? '${pack.price!.price.toString().seRagham()} ${intl.toman}'
                                        : '',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: 'Iransans-light',
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 0.7.w,
                                      decorationColor: Color.fromARGB(255, 150, 150, 150),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemOption(String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: context.textDirectionOfLocaleInversed,
      children: <Widget>[
        Expanded(
            child: Text(text,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(letterSpacing: -0.2, fontSize: 9.sp))),
        Space(width: 1.w),
        CircleAvatar(
          backgroundColor: color,
          radius: 1.w,
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 1.h),
            Text(
              widget.packageItem.name ?? 'package name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Space(height: 1.h),
            Text(
              widget.packageItem.price != null && widget.packageItem.price!.finalPrice != 0
                  ? '${widget.packageItem.price!.finalPrice.toString().seRagham()} ${intl.toman}'
                  : intl.free,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(74, 202, 150, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: 90.w,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              child: MaterialButton(
                height: 7.h,
                onPressed: () {
                  Navigator.pop(context);
                  VxNavigator.of(context)
                      .push(Uri.parse(Routes.billSubscription), params: widget.packageItem);
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: Color.fromRGBO(74, 202, 150, 1),
                child: Text(
                  intl.confirmContinue,
                  style: Theme.of(context).textTheme.button,
                ),
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
