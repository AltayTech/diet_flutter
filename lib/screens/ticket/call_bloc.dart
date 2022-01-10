import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/ticket/call_item.dart';
import 'package:rxdart/rxdart.dart';

class CallBloc {
  CallBloc() {
    getCalls();
  }

  final _repository = Repository.getInstance();
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _progressNetworkItem = BehaviorSubject<bool>();
  final _notFoundCall = BehaviorSubject<bool>();

  Call? _call;
  int? _callId;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get progressNetworkItem => _progressNetworkItem.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  Stream<bool> get notFoundCall => _notFoundCall.stream;

  Call? get call => _call;

  void getCalls() {
    _progressNetwork.value = true;
    _repository.getCalls().then((value) {
      _call = value.data;
      loadContent();
    }).whenComplete(() {
      if (!_progressNetwork.isClosed) _progressNetwork.value = false;
    });
  }

  void loadContent() {
    List<CallItem> callItems = [];
    int lengthCalls = _call!.items!.length;

    if (_call!.remainingCallNumber != null &&
        _call!.totalCallNumber != null &&
        _call!.totalCallNumber! > 0) {
      _notFoundCall.value = false;
      for (int i = 0; i < _call!.remainingCallNumber!; i++) {
        CallItem callItem = CallItem();
        callItem.done = false;
        callItem.isReserve = false;
        callItems.add(callItem);
      }
      _call!.items!.addAll(callItems);
      if (_call!.items!.length > 0 && lengthCalls > 0 && !_call!.items![lengthCalls - 1].done!) {
        _callId = _call!.items![lengthCalls - 1].id;
      } else if (_call!.items!.length > lengthCalls &&
          lengthCalls > 0 &&
          _call!.items![lengthCalls - 1].done!) {
        _call!.items![lengthCalls].isReserve = true;
      } else if (_call!.totalCallNumber == _call!.remainingCallNumber!) {
        _call!.items![0].isReserve = true;
      }
    } else {
      _notFoundCall.value = true;
    }
  }

  void sendCallRequest() {
    _progressNetworkItem.value = true;
    _repository.sendRequestCall().then((value) {
      getCalls();
    }).whenComplete(() {
      _progressNetworkItem.value = false;
    });
  }

  void deleteCallRequest() {
    _progressNetworkItem.value = true;
    _repository.deleteRequestCall(_callId!).then((value) {
      getCalls();
    }).whenComplete(() {
      _progressNetworkItem.value = false;
    });
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _progressNetworkItem.close();
    _notFoundCall.close();
    //  _isPlay.close();
  }
}
