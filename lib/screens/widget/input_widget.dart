import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  double height;
  TextInputType? textInputType;
  Function validation;
  Function onChanged;
  String? value;
  String? label;
  bool enable;
  bool maxLine;
  TextInputAction? action;
  TextDirection textDirection;
  TextAlign? textAlign;
  TextEditingController? textController;
  FilteringTextInputFormatter? formatter;

  InputWidget(
      {required this.height,
      this.textInputType,
      required this.validation,
      required this.onChanged,
      this.value,
      this.label,
      required this.enable,
      required this.maxLine,
      this.action,
      required this.textDirection,
      this.textAlign,
      this.textController,
      this.formatter}) {
    if (textController == null) {
      textController = TextEditingController(text: value ?? '');
    }
  }

  @override
  State createState() => InputWidgetState();
}

class InputWidgetState extends ResourcefulState<InputWidget> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO: implement build
    return Container(
        height: widget.height,
        child: Directionality(
            textDirection: widget.textDirection,
            child: TextFormField(
              inputFormatters: widget.formatter != null
                  ? [
                      widget.formatter!,
                    ]
                  : null,
              textInputAction: widget.action,
              maxLines: widget.maxLine ? 4 : 1,
              controller: widget.textController,
              enabled: widget.enable,
              decoration: inputDecoration.copyWith(
                labelText: widget.label,
                labelStyle:
                    Theme.of(context).textTheme.subtitle1!.copyWith(color: AppColors.labelColor),
              ),
              keyboardType: widget.textInputType,
              onChanged: (val) {
                widget.onChanged(val);
                widget.textController!.text=val;
                widget.textController!.selection = TextSelection.fromPosition(TextPosition(offset: widget.textController!.text.length));
              },
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: widget.textAlign ?? TextAlign.start,
              validator: (val) => widget.validation(val),
            )));
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
