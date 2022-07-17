import 'dart:async';

import 'package:behandam/extensions/stream.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class VitrinBloc {
  VitrinBloc() {
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  String? _url;
  final _waiting = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  String? get url => _url;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;

  void checkFitamin() async {
    _repository.checkFitamin().then((value) {
      _url = value.data!.url;
      if (_url!.contains('fitamin://'))
        IntentUtils.openApp('com.app.fitamin');
      else
        IntentUtils.launchURL(_url ?? 'https://land.fitamin.ir');
    });
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _waiting.close();
  }
}
