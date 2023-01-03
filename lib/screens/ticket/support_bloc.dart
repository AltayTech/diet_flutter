import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:rxdart/rxdart.dart';

class SupportBloc {
  SupportBloc() {}

  final _repository = Repository.getInstance();
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();

  String? linkWhatsApp;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void getCalls() {
    _progressNetwork.value = true;
    _repository.getCallSupport().then((value) {
      linkWhatsApp = "http://wa.me/${value.data?.supportEMobile?.mobile}";
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    //  _isPlay.close();
  }
}
