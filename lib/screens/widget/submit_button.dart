import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({Key? key, required this.label, this.icon, required this.onTap,this.size})
      : super(key: key);

  final String label;
  final Icon? icon;
  final Size? size;
  final void Function()? onTap;

  // final Icon icon,

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ResourcefulState<SubmitButton> {
  late AppBloc appBloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    appBloc = AppProvider.of(context);

    return widget.icon != null
        ? ElevatedButton.icon(

            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.primary),
                fixedSize: MaterialStateProperty.all(widget.size ?? Size(70.w, 6.h)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColors.primaryColorDark)))),
            onPressed: widget.onTap,

            icon: widget.icon!,
            label: Text(
              widget.label,
              style: typography.caption?.apply(
                color: AppColors.onPrimary,
              ),
            ),
          )
        : ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.primary),
                fixedSize: MaterialStateProperty.all(widget.size ?? Size(70.w, 6.h)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: AppColors.primaryColorDark)))),
            onPressed: widget.onTap,
            child: Text(
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
