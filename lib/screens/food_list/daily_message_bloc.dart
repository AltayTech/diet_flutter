
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';
import '../../data/entity/ticket/ticket_item.dart';

class DailyMessageBloc{
  DailyMessageBloc();

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _serverError = LiveEvent();
  final _navigateTo = LiveEvent();

  final _messageTemplate = BehaviorSubject<TempTicket>();
  Stream<TempTicket> get messageTemplate => _messageTemplate.stream;

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream get serverError => _serverError.stream;
  Stream get navigateTo => _navigateTo.stream;

  String? _messageTitle;
  String? get messageTitle => _messageTitle;



  void getDailyMessage(int id){
    _repository.getDailyMessage(id).then((value) {
      _messageTemplate.value = value.data!;
    });
  }

  void dispose(){
    _messageTemplate.close();
    _loadingContent.close();
  }
}