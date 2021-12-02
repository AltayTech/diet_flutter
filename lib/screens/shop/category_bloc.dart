import 'dart:async';
import 'package:behandam/data/entity/psychology/admin.dart';
import 'package:behandam/data/entity/psychology/calender.dart';
import 'package:behandam/data/entity/psychology/package.dart';
import 'package:behandam/data/entity/psychology/plan.dart';
import 'package:behandam/data/entity/psychology/reserved_meeting.dart';
import 'package:behandam/data/entity/shop/category.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class CategoryBloc{
  CategoryBloc(){
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  final _category = BehaviorSubject<Category>();

  bool _check = false;
  List<Plan>? _dates;
  List<Admin>? _admins;
  List<Package>? _packages;
  final _waiting = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _navigate = LiveEvent();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  bool get check => _check;
  List<Plan>? get dates => _dates;
  List<Admin>? get admins => _admins;
  List<Package>? get packages => _packages;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get navigate => _navigate.stream;
  Stream get navigateTo => _navigateTo.stream;
  Stream get showServerError => _showServerError.stream;

  Stream<Category> get category => _category.stream;


  void getInvoice(){
    try{
      _repository.getPsychologyInvoice().then((value) {
        _navigate.fire(value.data!.success);
        print('success:${value.data!.success}');
      });}catch(e) {
      print("Myerror:$e");
    }
  }

  void dispose() {
    _waiting.close();
    _showServerError.close();
    _navigateToVerify.close();
    _navigateTo.close();
    _navigate.close();
  }
}
