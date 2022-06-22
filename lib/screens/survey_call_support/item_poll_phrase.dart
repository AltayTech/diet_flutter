import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/subscription/select_package/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemPollPhrase extends StatefulWidget {
  late String text;
  late bool isSelected;

  ItemPollPhrase({required this.text, required this.isSelected});

  @override
  _ItemPollPhraseState createState() => _ItemPollPhraseState();
}

class _ItemPollPhraseState extends ResourcefulState<ItemPollPhrase> {
  late SelectPackageSubscriptionBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = SelectPackageSubscriptionBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return _item(widget.text, widget.isSelected);
  }

  Widget _item(String text, bool isSelected) {
    return InkWell(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: context.textDirectionOfLocaleInversed,
          children: <Widget>[
            Expanded(
                child: Text(text,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(letterSpacing: -0.2, fontWeight: FontWeight.w400))),
            Space(width: 2.w),
            ImageUtils.fromLocal(
              isSelected ? 'assets/images/bill/check.svg' : 'assets/images/bill/not_select.svg',
              width: 4.w,
              height: 4.w,
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
