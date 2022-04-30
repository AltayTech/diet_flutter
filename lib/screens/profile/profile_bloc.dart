import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class ProfileBloc {
  ProfileBloc() {}

  final _repository = Repository.getInstance();
  ImagePicker? _picker;
  XFile? image;
  late CityProvinceModel cityProvinceModel;
  late String countryName;

  late UserInformation _userInformation;
  final _showServerError = LiveEvent();
  final _navigateTo = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _showProgressItem = BehaviorSubject<bool>();
  final _showProgressUploadImage = BehaviorSubject<bool>();
  final _inboxCount = BehaviorSubject<int>();
  final _userInformationStream = BehaviorSubject<UserInformation>();
  final _showRefund = BehaviorSubject<bool>();
  final _showPdf = BehaviorSubject<bool>();
  final _inboxStream = BehaviorSubject<List<InboxItem>>();
  final _cityProvinceModelStream = BehaviorSubject<CityProvinceModel>();
  final _navigateToVerify = LiveEvent();
  String? _url;

  String? get url => _url;

  Stream get navigateToVerify => _navigateToVerify.stream;

  UserInformation get userInfo => _userInformation;

  Stream get showServerError => _showServerError.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<int> get inboxCount => _inboxCount.stream;

  Stream<bool> get showProgressUploadImage => _showProgressUploadImage.stream;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  Stream<UserInformation> get userInformationStream => _userInformationStream.stream;

  Stream<bool> get showRefund => _showRefund.stream;

  Stream<bool> get showPdf => _showPdf.stream;

  Stream<List<InboxItem>> get inboxStream => _inboxStream.stream;

  Stream<CityProvinceModel> get cityProvinceModelStream => _cityProvinceModelStream.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void getInformation() {
    if (MemoryApp.countries == null) {
      fetchCountries();
    }
    fetchUserInformation();
  }

  void fetchCountries() {
    _repository.country().then((value) {
      MemoryApp.countries = value.data!;
    });
  }

  void fetchUserInformation() async {
    _progressNetwork.safeValue = true;
    if (MemoryApp.userInformation == null) {
      _repository.getUser().then((value) {
        debugPrint('value ==> ${value.data!.firstName}');
        _userInformation = value.data!;
        MemoryApp.userInformation = _userInformation;
        getProvinces();
        _userInformationStream.safeValue = value.data!;
      }).catchError((onError) {
        debugPrint('onError ==> ${onError.toString()}');
      }).whenComplete(() {
        _progressNetwork.safeValue = false;
      });
    } else {
      _userInformation = MemoryApp.userInformation!;
      _userInformationStream.safeValue = _userInformation;
      if (MemoryApp.cityProvinceModel == null)
        getProvinces();
      else {
        cityProvinceModel = MemoryApp.cityProvinceModel!;
        _cityProvinceModelStream.safeValue = cityProvinceModel;
      }
      _progressNetwork.safeValue = false;
    }
    getUnreadInbox();
    getTermPackage();
  }

  void getUnreadInbox() {
    _repository.getUnreadInbox().then((value) {
      _inboxCount.safeValue = value.data!.count ?? 0;
      MemoryApp.inboxCount = value.data!.count ?? 0;
    });
  }

  void getInbox() {
    _repository.getInbox().then((value) {
      print('data => ${value.data!.toJson()}');
      _inboxStream.safeValue = value.data!.items!;
    }).onError((error, stackTrace) {
      print('data => ${error.toString()}');
    });
  }

  void seenInbox(int id) {
    _repository.seenInbox(id).then((value) {
      getUnreadInbox();
    }).onError((error, stackTrace) {
      print('data => ${error.toString()}');
    });
  }

  void getPdfMeal(FoodDietPdf type) {
    _showProgressItem.safeValue = true;
    _repository.getPdfUrl(type).then((value) {
      launchURL(value.data!.url!);
      // Share.share(value['data']['url'])
    }).catchError((onError) {
      _showServerError.fireMessage(onError);
    }).whenComplete(() {
      _showProgressItem.safeValue = false;
    });
  }

  void getTermPackage() {
    _repository.getTermPackage().then((value) {
      _showRefund.safeValue = value.data!.showRefundLink!;
      if (value.data != null &&
          value.data?.term != null &&
          DateTime.parse(value.data!.term!.expiredAt).difference(DateTime.now()).inDays >= 0 &&
          !_showPdf.isClosed)
        _showPdf.safeValue = true;
      else {
        _showPdf.safeValue = false;
      }
    }).whenComplete(() {});
  }

  void dispose() {
    _showServerError.close();
    _progressNetwork.close();
    _showProgressItem.close();
    _userInformationStream.close();
    _cityProvinceModelStream.close();
    _showProgressUploadImage.close();
    _showRefund.close();
    _showPdf.close();
    _inboxCount.close();
    _navigateTo.close();
    //  _isPlay.close();
  }

  void getProvinces() {
    _repository.getProvinces().then((value) {
      cityProvinceModel = value.data!;
      _cityProvinceModelStream.safeValue = value.data!;
      MemoryApp.cityProvinceModel = cityProvinceModel;
      changeProvinceCity();
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
        userInfo.address!.cityId = null;
        print("cityProvinceModel.cities ==> ${city.toJson()}");
      }
    });
    cityProvinceModel.cities = relatedCities;
    print("cityProvinceModel.cities ==> ${cityProvinceModel.cities!.length}");
  }

  dynamic findCountryName() {
    var item = MemoryApp.countries?.firstWhere(
      (element) => element.id == userInfo.countryId,
      orElse: () => Country(),
    );
    countryName = item?.name ?? '';
    return item;
  }

  dynamic findProvincesName() {
    if (userInfo.address != null) {
      print("address = > ${userInfo.address!.toJson()}");
      if (userInfo.address!.provinceId != null) {
        var name = cityProvinceModel.provinces.firstWhere(
          (element) => element.id == userInfo.address!.provinceId,
          orElse: () => CityProvince(),
        );
        print("ProvincesName = > ${name.name}");
        return name;
      } else
        return null;
    } else {
      return null;
    }
  }

  dynamic findCityName() {
    if (userInfo.address != null &&
        cityProvinceModel.cities != null &&
        cityProvinceModel.cities!.length > 0) {
      //print("address = > ${cityProvinceModel.cities?.length}");
      var item;
      if (userInfo.address!.cityId != null) {
        item = cityProvinceModel.cities?.firstWhere(
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
      _showProgressUploadImage.safeValue = true;
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
        _showProgressUploadImage.safeValue = false;
      });
    }
  }

  void selectCamera() async {
    if (_picker == null) _picker = ImagePicker();
    // Pick an image
    image = await _picker!.pickImage(source: ImageSource.camera);
    if (image != null) {
      _showProgressUploadImage.safeValue = true;
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
        _showProgressUploadImage.safeValue = false;
      });
    }
  }

  void edit(BuildContext context) async {
    UserInformationEdit userInformationEdit = UserInformationEdit();
    if (userInfo.address != null && userInfo.address!.cityId != null) {
      userInfo.cityId = userInfo.address!.cityId;
    }
    if (userInfo.address != null && userInfo.address!.provinceId != null) {
      userInfo.provinceId = userInfo.address!.provinceId;
    }
    List<SocialMediaEdit> social = [];
    if (userInfo.socialMedia != null)
      userInfo.socialMedia!.forEach((element) {
        SocialMediaEdit socialMediaEdit = SocialMediaEdit();
        socialMediaEdit.link = element.pivot?.link;
        socialMediaEdit.socialMediaId = element.id;
        debugPrint('${socialMediaEdit.toJson()}');
        social.add(socialMediaEdit);
      });
    userInformationEdit.socialMedia = social;
    userInformationEdit.firstName = userInfo.firstName;
    userInformationEdit.lastName = userInfo.lastName;
    userInformationEdit.callNumber = userInfo.callNumber;
    userInformationEdit.email = userInfo.email;
    userInformationEdit.address = userInfo.address?.address;
    userInformationEdit.countryId = userInfo.countryId;
    userInformationEdit.cityId = userInfo.cityId;
    userInformationEdit.provinceId = userInfo.provinceId;
    DialogUtils.showDialogProgress(context: context);
    _repository.changeProfile(userInformationEdit).then((value) {
      Utils.getSnackbarMessage(context, value.message!);
      Navigator.of(context).pop();
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) Navigator.of(context).pop();
    });
  }

  void resetPasswordMethod(Reset pass) {
    _repository.reset(pass).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      _showServerError.fire(value.message);
    }).whenComplete(() => _navigateTo.fire(true));
  }

  void checkFitamin() async {
    _repository.checkFitamin().then((value) {
      _url = value.data!.url;
      _navigateToVerify.fire(url);
    });
  }

  void logOut() {
    _repository.logout().whenComplete(() {
      AppSharedPreferences.logout();
      navigator.routeManager.clearAndPush(Uri.parse(Routes.auth));
    });
  }
}
