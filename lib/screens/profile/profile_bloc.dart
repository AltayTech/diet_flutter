import 'dart:async';

import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';

import 'package:behandam/screens/widget/widget_box.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class ProfileBloc {
  AuthenticationBloc? loginRegisterBloc;

  ProfileBloc() {
    if (loginRegisterBloc == null) {
      loginRegisterBloc = AuthenticationBloc();
    }
    fetchUserInformation();
  }

  final _repository = Repository.getInstance();

  bool showRefund = false;
  bool showPdf = false;
  late CityProvinceModel cityProvinceModel;
  late String countryName;

  late UserInformation _userInformation;
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _showProgressItem = BehaviorSubject<bool>();
  final _userInformationStream = BehaviorSubject<UserInformation>();
  final _cityProvinceModelStream = BehaviorSubject<CityProvinceModel>();

  UserInformation get userInfo => _userInformation;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  Stream<UserInformation> get userInformationStream => _userInformationStream.stream;

  Stream<CityProvinceModel> get cityProvinceModelStream => _cityProvinceModelStream.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void fetchUserInformation() async {
   if( MemoryApp.userInformation==null) {
     _progressNetwork.value = true;
     _repository.getUser().then((value) {
       print('value ==> ${value.data!.firstName}');
       _userInformation = value.data!;
       MemoryApp.userInformation=_userInformation;
       getProvinces();
       _userInformationStream.value = value.data!;
     }).catchError((onError) {
       print('onError ==> ${onError.toString()}');
     }).whenComplete(() {
       _progressNetwork.value = false;
     });
   }else{
     _userInformation=MemoryApp.userInformation!;
     _userInformationStream.value = _userInformation;
     cityProvinceModel = MemoryApp.cityProvinceModel!;
     _cityProvinceModelStream.value = cityProvinceModel;
   }
  }

  void getPdfMeal(FoodDietPdf type) {
    _showProgressItem.value = true;
    _repository.getPdfUrl(type).then((value) {
      launchURL(value.data!.url!);
      // Share.share(value['data']['url'])
    }).catchError((onError) {
      _showServerError.fireMessage(onError);
    }).whenComplete(() {
      _showProgressItem.value = false;
    });
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _showProgressItem.close();
    _userInformationStream.close();
    loginRegisterBloc!.dispose();
    _cityProvinceModelStream.close();
    //  _isPlay.close();
  }

  void getProvinces() {
    _repository.getProvinces().then((value) {
      cityProvinceModel = value.data!;
      _cityProvinceModelStream.value = value.data!;
      MemoryApp.cityProvinceModel=cityProvinceModel;
    }).onError((error, stackTrace) {
      print('err=> $error');
    });
  }

  List<CityProvince> relatedCities = [];

  void changeProvinceCity() {
    relatedCities.clear();
    cityProvinceModel.allCities.forEach((CityProvince city) {
      if (city.provinceId == userInfo.address!.provinceId) {
        relatedCities.add(city);
        print("cityProvinceModel.cities ==> ${city.toJson()}");
      }
    });
    cityProvinceModel.cities = relatedCities;
    print("cityProvinceModel.cities ==> ${cityProvinceModel.cities!.length}");
  }

  dynamic findCountryName() {
    print("countris = > ${loginRegisterBloc!.countries.length}");
    var item = loginRegisterBloc!.countries.firstWhere(
      (element) => element.id == userInfo.countryId,
      orElse: () => CountryCode(),
    );
    countryName = item.name ?? '';
    return item;
  }

  dynamic findProvincesName() {
    if (userInfo.address != null) {
      print("address = > ${userInfo.address!.toJson()}");
      var name = cityProvinceModel.provinces.firstWhere(
        (element) => element.id == userInfo.address!.provinceId,
        orElse: () => CityProvince(),
      );
      print("ProvincesName = > ${name.name}");
      return name;
    } else {
      return null;
    }
  }

  dynamic findCityName() {
    if (userInfo.address != null) {
      print("address = > ${userInfo.address!.toJson()}");
      var item;
      if (userInfo.address!.cityId != null) {
        item = cityProvinceModel.cities!.firstWhere(
          (element) => element.id == userInfo.address!.cityId,
          orElse: () => CityProvince(),
        );
      } else {
        item = cityProvinceModel.cities![0];
      }
      print("CityName = > ${item.name}");
      return item;
    } else {
      return null;
    }
  }
}
