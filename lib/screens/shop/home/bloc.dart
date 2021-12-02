import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:rxdart/rxdart.dart';

class ShopHomeBloc {
  ShopHomeBloc() {
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  late List<ShopItem> _list;

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream get navigateTo => _navigateTo.stream;
  Stream get showServerError => _showServerError.stream;

  List<ShopItem> get list => _list;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.getHomeShop().then((value) {
      _list = value.data!.items!;
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
