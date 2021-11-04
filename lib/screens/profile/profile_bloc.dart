import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/lgn_reg/lgnReg_bloc.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class ProfileBloc {
  LoginRegisterBloc? loginRegisterBloc;

  ProfileBloc() {
    if (loginRegisterBloc == null) {
      loginRegisterBloc = LoginRegisterBloc();
    }
    fetchUserInformation();
  }

  final _repository = Repository.getInstance();
  ImagePicker? _picker;
  XFile? image;
  bool showRefund = false;
  bool showPdf = false;
  late CityProvinceModel cityProvinceModel;
  late String countryName;

  late UserInformation _userInformation;
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _showProgressItem = BehaviorSubject<bool>();
  final _showProgressUploadImage = BehaviorSubject<bool>();
  final _userInformationStream = BehaviorSubject<UserInformation>();
  final _cityProvinceModelStream = BehaviorSubject<CityProvinceModel>();

  UserInformation get userInfo => _userInformation;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get showProgressUploadImage => _showProgressUploadImage.stream;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  Stream<UserInformation> get userInformationStream => _userInformationStream.stream;

  Stream<CityProvinceModel> get cityProvinceModelStream => _cityProvinceModelStream.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void fetchUserInformation() async {
    _progressNetwork.value = true;
    if (MemoryApp.userInformation == null) {

      _repository.getUser().then((value) {
        print('value ==> ${value.data!.firstName}');
        _userInformation = value.data!;
        MemoryApp.userInformation = _userInformation;
        getProvinces();
        _userInformationStream.value = value.data!;
      }).catchError((onError) {
        print('onError ==> ${onError.toString()}');
      }).whenComplete(() {
        _progressNetwork.value = false;
      });
    } else {

      loginRegisterBloc!.subjectList.listen((event) {
        _userInformation = MemoryApp.userInformation!;
        _userInformationStream.value = _userInformation;
        cityProvinceModel = MemoryApp.cityProvinceModel!;
        _cityProvinceModelStream.value = cityProvinceModel;
        _progressNetwork.value = false;
      });
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
    _showProgressUploadImage.close();
    //  _isPlay.close();
  }

  void getProvinces() {
    _repository.getProvinces().then((value) {
      cityProvinceModel = value.data!;
      _cityProvinceModelStream.value = value.data!;
      MemoryApp.cityProvinceModel = cityProvinceModel;
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

  void selectGallery() async {
    if (_picker == null) _picker = ImagePicker();
    // Pick an image
    image = await _picker!.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _showProgressUploadImage.value = true;
      _repository
          .sendMedia(
              jsonEncode({
                "collectionName": "avatar",
                "entityType": "App\\Profile",
                "entityId": userInfo.userId,
                "width": 300,
              }),
              File(image!.path))
          .then((value) {
        if (userInfo.media == null) userInfo.media = Media();
        userInfo.media!.url = value.data!.url;
      }).whenComplete(() {
        _showProgressUploadImage.value = false;
      });
    }
  }

  void selectCamera() async {
    if (_picker == null) _picker = ImagePicker();
    // Pick an image
    image = await _picker!.pickImage(source: ImageSource.camera);
    if (image != null) {
      _showProgressUploadImage.value = true;
      _repository
          .sendMedia(
              jsonEncode({
                "collectionName": "avatar",
                "entityType": "App\\Profile",
                "entityId": userInfo.userId,
                "width": 300,
              }),
              File(image!.path))
          .then((value) {
        if (userInfo.media == null) userInfo.media = Media();
        userInfo.media!.url = value.data!.url;
      }).whenComplete(() {
        _showProgressUploadImage.value = false;
      });
    }
  }


}
