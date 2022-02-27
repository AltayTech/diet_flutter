
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';
import '../../data/entity/daily_message.dart';

class DailyMessageBloc{
  DailyMessageBloc();

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _serverError = LiveEvent();
  final _navigateTo = LiveEvent();

  final _messageTemplate = BehaviorSubject<DailyMessageTemplate>();
  Stream<DailyMessageTemplate> get messageTemplate => _messageTemplate.stream;

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream get serverError => _serverError.stream;
  Stream get navigateTo => _navigateTo.stream;

  String? _messageTitle;
  String? get messageTitle => _messageTitle;

  void getDailyMessage(int id){
    _repository.getDailyMessage(id).then((value) {
      _messageTemplate.value = value.data!;
      // _messageTitle = value.data!.title;
    });
  }
}