import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:behandam/api/error/error_observer.dart';
import 'package:behandam/extensions/build_context.dart';

export 'package:sizer/sizer.dart';
export 'package:behandam/extensions/build_context.dart';
import '../entry_point.dart';

abstract class ResourcefulState<T extends StatefulWidget> extends State<T> with RouteAware, DioErrorListener {
  late AppLocalizations intl;
  late TextTheme typography;
  final bool _printLifecycleEvents = true;
  final bool _printPageEventsOnly = true;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    intl = context.intl;
    typography = context.typography;

    return Text('Not implemented body');
  }

  String get _widgetName => this.widget.toStringShort();

  void _printEvent(String message) {
    if (_printPageEventsOnly && !_widgetName.endsWith('Page')) {
      return;
    }
    if (_printLifecycleEvents) {
      debugPrint('ResourcefulState => $_widgetName: $message');
    }
  }

  @override
  void dispose() {
    _printEvent('dispose()');
    routeObserver.unsubscribe(this);
    dioErrorObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    _printEvent('initState()');
    dioErrorObserver.subscribe(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _printEvent('didChangeDependencies()');
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    _printEvent('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  /* @override
  @mustCallSuper
  void onResume() {
    _printEvent('onResume()');
  }

  @override
  @mustCallSuper
  void onPause() {
    _printEvent('onPause()');
  }

  @override
  @mustCallSuper
  void onReady() {
    _printEvent('onReady()');
  }*/

  @override
  @mustCallSuper
  void didPush() {
    _printEvent('didPush()');
  }

  @override
  @mustCallSuper
  void didPushNext() {
    _printEvent('didPushNext()');
  }

  @override
  @mustCallSuper
  void didPop() {
    _printEvent('didPop()');
  }

  @override
  @mustCallSuper
  void didPopNext() {
    _printEvent('didPopNext()');
  }
}
