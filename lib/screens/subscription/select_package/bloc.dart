import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class SelectPackageSubscriptionBloc {
  SelectPackageSubscriptionBloc() {}

  List<PackageItem>? _list;

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  List<PackageItem>? get packageList => _list;

  void getPackageSubscriptionList(int type) {
    _progressNetwork.safeValue = true;

    _repository.getPackagesList(type).then((value) {
      _list = value.data!.items;
      for (int i = 0; i < _list!.length; i++) {
        _list![i].index = i;
      }
    }).whenComplete(() {
      _progressNetwork.safeValue = false;
    });
  }

  void dispose() {
    _progressNetwork.close();
  }
}
