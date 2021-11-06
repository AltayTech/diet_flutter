import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:rxdart/rxdart.dart';



class TicketBloc {

  TicketBloc() {
    getTickets();
  }

  final _repository = Repository.getInstance();
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _showProgressItem = BehaviorSubject<bool>();

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void getTickets(){
    _progressNetwork.value = true;

    _repository.getTickets().then((value) {
      print('value ==> ${value.data!}');
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }


  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _showProgressItem.close();
    //  _isPlay.close();
  }
}
