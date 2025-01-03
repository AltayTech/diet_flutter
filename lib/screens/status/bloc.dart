import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/status/visit_item.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';
class StatusBloc {
  StatusBloc() {
    _waiting.safeValue = true;
  }

  Repository _repository = Repository.getInstance();

  late String _path;
  late List<TermStatus>? _terms;
  VisitItem? _visitItem;

  final _waiting = BehaviorSubject<bool>();
  final _showInformation = BehaviorSubject<bool>();

  String get path => _path;

  List<TermStatus> get terms => _terms ?? [];

  VisitItem? get visitItem => _visitItem;

  TermStatus? get activeTerms => (terms.length>0 && terms.where((element) => element.isActive == 1).isNotEmpty) ? terms.where((element) => element.isActive == 1).first : ((terms.length>0) ? _terms![0] : null);
  //TermStatus? get activeTerms => _terms![0];

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get showInformation => _showInformation.stream;

  void getVisitUser() {
    _waiting.safeValue = true;
    _repository.getVisits().then((value) {
      _visitItem = value.data;
      _terms = value.data?.terms;
      if(terms.length>0) {
        _terms?.sort((TermStatus a, TermStatus b) =>
        (DateTime
            .parse(a.startedAt.substring(0, 10))
            .millisecond > DateTime
            .parse(b.startedAt.substring(0, 10))
            .millisecond) ? 0 : 1);
        _terms?.forEach((element) {
          element.setMaxMinWeight();
        });
      }
    }).catchError((onError) {
      _visitItem = new VisitItem();
      _visitItem!.terms = [];
      _terms = [];
    }).whenComplete(() {
      _waiting.safeValue = false;
    });
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryLoadingPage(){
    setRepository();
    getVisitUser();
  }

  void dispose() {
    _showInformation.close();
    _waiting.close();
  }
}
