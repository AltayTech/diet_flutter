import 'dart:async';
import 'dart:math';
import 'package:behandam/const_&_model/selected_time.dart';
import 'package:behandam/data/entity/psychology/admin.dart';
import 'package:behandam/data/entity/psychology/booking.dart';
import 'package:behandam/data/entity/psychology/calender.dart';
import 'package:behandam/data/entity/psychology/package.dart';
import 'package:behandam/data/entity/psychology/plan.dart';
import 'package:behandam/data/entity/psychology/reserved_meeting.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class CalenderBloc{
  CalenderBloc(){
    _waiting.value = false;
    // if(MemoryApp.day == null)
  }

  final _repository = Repository.getInstance();

  String? start;
  String? end;
  List<SelectedTime>? advisersPerDay = [];
  List<SelectedTime>? advisersFree = [];
  bool flag1 = false;
  bool flag2 = false;
  String? url;

  final _disabledClick = BehaviorSubject<bool>();
  final _disabledClickPre = BehaviorSubject<bool>();
  final _daysLater = BehaviorSubject<Jalali>();
  final _daysAgo = BehaviorSubject<Jalali>();

  bool _check = false;
  List<Plan>? _dates;
  List<Admin>? _admins;
  List<Package>? _packages;
  final _waiting = BehaviorSubject<bool>();
  final _data = BehaviorSubject<CalenderOutput>();
  final _meetingDate = BehaviorSubject<List<HistoryOutput>>();
  final _navigateToVerify = LiveEvent();
  final _navigate = LiveEvent();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  bool get check => _check;
  List<Plan>? get dates => _dates;
  List<Admin>? get admins => _admins;
  List<Package>? get packages => _packages;
  Stream<CalenderOutput> get data => _data.stream;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get navigate => _navigate.stream;
  Stream get navigateTo => _navigateTo.stream;
  Stream get showServerError => _showServerError.stream;

  Stream<bool> get disabledClick => _disabledClick.stream;
  Stream<bool> get disabledClickPre => _disabledClickPre.stream;
  Stream<Jalali> get daysLater => _daysLater.stream;
  Stream<Jalali> get daysAgo => _daysAgo.stream;
  Stream<List<HistoryOutput>>? get meetingDate => _meetingDate.stream;


  void getCalender(Jalali jour) async {
    MemoryApp.day = jour;
    _daysLater.value = jour.addDays(10);
    _daysAgo.value = jour.addDays(-10);
    DateTime today = jour.toGregorian().toDateTime();
    start = today.toString().substring(0, 10);
    end = today.add(Duration(days: 9)).toString().substring(0, 10);
    calenderMethod(start!, end!, jour);
  }

  findFirstFreeTime(){
    if(_dates!.where((element) => element.expertPlanning!.length > 0).isNotEmpty) {
      var data = _dates?.firstWhere((element) =>
      element.expertPlanning != null && element.expertPlanning!.length > 0);
      advisersFree!.clear();
      var expertPlannings =
          _dates!.firstWhere((element) => element.jDate == data!.jDate)
              .expertPlanning;
      var admin = _admins!
          .firstWhere((admin) => admin.adminId == expertPlannings![0].adminId);
      var package = _packages!
          .firstWhere((package) => admin.packageId == package.id);
      advisersFree!.add(SelectedTime(
        adviserId: expertPlannings![0].id,
        adviserName: admin.name,
        adviserImage: admin.image,
        packageId: admin.packageId,
        date: data!.jDate,
        price: package.price!.price,
        finalPrice: package.price!.finalPrice,
        duration: package.time,
        times: expertPlannings[0].dateTimes,
        role: admin.role,
      ));
      return advisersFree;
    }
    else
      return [];
  }

  void calenderMethod(String startDate ,String endDate, Jalali jour) async {
    _waiting.value = true;
    _disabledClickPre.value = true;
    _disabledClick.value = true;
    _repository.getCalendar(startDate, endDate).then((value) {
      _data.value = value.data!;
      _admins = value.data!.admins!;
      _packages = value.data!.packages!;
      _dates = value.data!.dates!;
      _navigateToVerify.fire(true);
    }).whenComplete(() {
      _waiting.value = false;
      _disabledClick.value = false;
      if (jour.toString().substring(7,18) != Jalali.now().toString().substring(7,18))
        _disabledClickPre.value = false;

    });
  }


  giveInfo(String date) {
    advisersPerDay!.clear();
    var expertPlannings =
        _dates!.firstWhere((element) => element.jDate == date).expertPlanning;
    if (expertPlannings!.isNotEmpty) {
      flag1 = true;
    } else {
      flag1 = false;
    }
    for (var plan in expertPlannings) {
      var admin = _admins!
          .firstWhere((admin) => admin.adminId == plan.adminId);
      var package = _packages!
          .firstWhere((package) => admin.packageId == package.id);
      advisersPerDay!.add(SelectedTime(
        adviserId: plan.id,
        adviserName: admin.name,
        adviserImage: admin.image,
        packageId: admin.packageId,
        date: date,
        price: package.price!.price,
        finalPrice: package.price!.finalPrice,
        duration: package.time,
        times: plan.dateTimes,
        role: admin.role,
      ));
    }

  }

  void getHistory(){
    if(!_check) {
      _repository.getHistory().then((value) {
        _meetingDate.value = value.data!.dates!;
        if (_meetingDate.value.isNotEmpty) {
          _navigateTo.fire(true);
          _check = true;
        }
        if (_meetingDate.value.isEmpty) {
          _navigateTo.fire(false);
          // _check = false;
        }
      });
    }
    else
      _navigateTo.fire(false);
  }

  void getBook(Booking booking){
    _repository.getBook(booking).then((value) async{
      url = value.data!.url;
      if (await canLaunch(url!)) {
       await launch(url!);
      } else {
      throw "Could not launch $url";
      }
    });
  }

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
    _showServerError.close();
    _navigateToVerify.close();
    _waiting.close();
    _disabledClickPre.close();
    _disabledClick.close();
    _daysAgo.close();
    _daysLater.close();
    _meetingDate.close();
    _navigateTo.close();
    _navigate.close();
  }
}
