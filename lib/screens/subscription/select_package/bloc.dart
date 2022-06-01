import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class SelectPackageSubscriptionBloc {
  SelectPackageSubscriptionBloc() {}

  List<PackageItem>? _list;
  PackageItem? _packageItem;

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream get navigateTo => _navigateTo.stream;

  List<PackageItem>? get packageList => _list;

  PackageItem get packageItem => _packageItem!;

  set setPackageItem(PackageItem packageItem) => _packageItem = packageItem;

  void getPackageSubscriptionList() {
    _progressNetwork.safeValue = true;

    _repository.getPackagesList().then((value) {
      _list = value.data!.items;
      for (int i = 0; i < _list!.length; i++) {
        _list![i].index = i;
      }
    }).whenComplete(() {
      _progressNetwork.safeValue = false;
    });
  }

  void sendPackage() {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.reservePackageId = _packageItem!.id;
    _repository.setUserReservePackage(requestData).then((value) {
      _navigateTo.fire(value.next);
    });
  }

  void dispose() {
    _progressNetwork.close();
    _navigateTo.close();
  }
}
