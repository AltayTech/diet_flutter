import 'dart:async';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:rxdart/rxdart.dart';

class ShopHomeBloc {
  ShopHomeBloc() {

  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  List<ShopItem>? _list;

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream get navigateTo => _navigateTo.stream;
  Stream get showServerError => _showServerError.stream;

  List<ShopItem>? get list => _list;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.getHomeShop().then((value) {
      _list = value.data!.items!;
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _loadingContent.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
