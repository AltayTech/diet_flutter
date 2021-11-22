import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  final String label;
  final Function onTap;
  // final Icon icon,

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ResourcefulState<SubmitButton> {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ElevatedButton.icon(
      onPressed: () => widget.onTap.call(),
      icon: Icon(Icons.circle),
      label: Text(
        widget.label,
        style: typography.caption?.apply(
          color: AppColors.onPrimary,
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
