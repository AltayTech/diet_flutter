import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypeTicket { MESSAGE, RECORD, IMAGE }

class TicketBloc {
  TicketBloc() {
    changeType(TypeTicket.MESSAGE);
  }

  final _repository = Repository.getInstance();
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _typeTicket = BehaviorSubject<TypeTicket>();
  final _SupportItems = BehaviorSubject<List<SupportItem>>();
  final _showProgressItem = BehaviorSubject<bool>();
  List<TicketItem> _listTickets = [];
  int? selectedSupportId;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<TypeTicket> get typeTicket => _typeTicket.stream;
  List<SupportItem> get SupportItems => _SupportItems.stream.value;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  List<TicketItem> get listTickets => _listTickets;

  void getTickets() {
    _progressNetwork.value = true;

    _repository.getTickets().then((value) {
      print('value ==> ${value.data!.toJson()}');
      _listTickets = value.data!.items;
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  String findTicketStatus(TicketStatus status) {
    print('status = > ${status.index}');
    switch (status) {
      case TicketStatus.Resolved:
        return 'حل شده';
      case TicketStatus.Closed:
        return 'بسته شده';
      case TicketStatus.PendingAdminResponse:
        return 'در انتظار پاسخ';
      case TicketStatus.PendingUserResponse:
        return 'پیام جدید';
      case TicketStatus.OnHold:
        return 'در حال بررسی';
      case TicketStatus.GlobalIssue:
        return 'مشکل سراسری';
    }
  }

  Color statusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.Resolved:
        return AppColors.statusTicketResolved;
      case TicketStatus.Closed:
        return AppColors.statusTicketClose;
      case TicketStatus.PendingAdminResponse:
        return AppColors.statusTicketPendingAdminResponse;
      case TicketStatus.PendingUserResponse:
        return AppColors.statusTicketPendingUserResponse;
      case TicketStatus.OnHold:
        return AppColors.statusTicketOnHold;
      case TicketStatus.GlobalIssue:
        return AppColors.statusTicketGlobalIssue;
    }
  }

  void changeType(TypeTicket typeTicket) {
    _typeTicket.value = typeTicket;
  }

  void getSupportList() {
    _progressNetwork.value = true;
    _repository.getDepartmentItems().then((value) {
      _SupportItems.value=value.data!.items;
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _showProgressItem.close();
    //  _isPlay.close();
  }
}
