import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/user/block_user.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

class BlockUserBloc {
  BlockUserBloc() {}

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();

  final _blockUser = BehaviorSubject<BlockUser>();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<BlockUser> get blockUser => _blockUser.stream;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.getBlockUserDescription().then((value) {
      _blockUser.safeValue = value.data!.items![0];
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryAfterNoInternet() {
    setRepository();
  }

  void onRetryLoadingPage() {
    setRepository();
    loadContent();
  }

  void dispose() {
    _loadingContent.close();
    _blockUser.close();
  }
}
