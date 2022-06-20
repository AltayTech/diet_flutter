import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:flutter/material.dart';

class SurveyCallSupportProvider extends InheritedWidget {
  final SurveyCallSupportBloc bloc;

  const SurveyCallSupportProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SurveyCallSupportBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SurveyCallSupportProvider>()!.bloc;
  }
}