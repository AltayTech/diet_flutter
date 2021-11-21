import 'dart:async';
import 'package:behandam/data/entity/psy/admin.dart';
import 'package:behandam/data/entity/psy/calender.dart';
import 'package:behandam/data/entity/psy/package.dart';
import 'package:behandam/data/entity/psy/plan.dart';
import 'package:behandam/data/entity/regime/body_state.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class CalenderBloc{
  CalenderBloc(){
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  List<Plan>? _calenderDates;
  List<Admin>? _calenderAdmins;
  List<Package>? _calenderPackages;
  final _waiting = BehaviorSubject<bool>();
  final _calenderData = BehaviorSubject<CalenderOutput>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  List<Plan>? get calenderDates => _calenderDates;
  List<Admin>? get calenderAdmins => _calenderAdmins;
  List<Package>? get calenderPackages => _calenderPackages;
  Stream<CalenderOutput> get calenderData => _calenderData.stream;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;

  void calenderMethod(String startDate ,String endDate) async {
    _waiting.value = true;
    _repository.getCalendar(startDate, endDate).then((value) {
      _calenderData.value = value.data!;
      print("data: ${_calenderData.value}");
      _calenderAdmins = value.data!.admins!;
      _calenderPackages = value.data!.packages!;
      _calenderDates = value.data!.dates!;
      print("dates: $_calenderDates");
    }).whenComplete(() => _waiting.value = false);
  }


  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _waiting.close();
  }
}
