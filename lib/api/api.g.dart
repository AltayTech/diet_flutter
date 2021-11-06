// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<NetworkResponse<List<CountryCode>>> getCountries() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<List<CountryCode>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/country',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<List<CountryCode>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<CountryCode>(
                (i) => CountryCode.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<NetworkResponse<CheckStatus>> checkUserStatus(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CheckStatus>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/check-user-status?mobile=$mobile',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CheckStatus>.fromJson(
      _result.data!,
      (json) => CheckStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<SignIn>> signInWithPhoneNumber(user) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
<<<<<<< HEAD
=======
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
>>>>>>> develop
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<SignIn>>(
<<<<<<< HEAD
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/login',
=======
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/login?mobile=$mobile&password=$pass',
>>>>>>> develop
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<SignIn>.fromJson(
      _result.data!,
      (json) => SignIn.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VerificationCode>> sendVerificationCode(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerificationCode>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/send-verification-code?mobile=$mobile',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VerificationCode>.fromJson(
      _result.data!,
      (json) => VerificationCode.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VerifyOutput>> verifyUser(verificationCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
<<<<<<< HEAD
    queryParameters.addAll(verificationCode.toJson());
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerifyOutput>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/verify',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
=======
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerifyOutput>>(Options(
                method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, '/verify?mobile=$mobile&verification_code=$code',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
>>>>>>> develop
    final value = NetworkResponse<VerifyOutput>.fromJson(
      _result.data!,
      (json) => VerifyOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ResetOutput>> resetPassword(password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(password.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ResetOutput>>(
            Options(method: 'PATCH', headers: _headers, extra: _extra)
                .compose(_dio.options, '/reset-password',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ResetOutput>.fromJson(
      _result.data!,
      (json) => ResetOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<RegisterOutput>> registerWithPhoneNumber(
      mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(mobile.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegisterOutput>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/register',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RegisterOutput>.fromJson(
      _result.data!,
      (json) => RegisterOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
<<<<<<< HEAD
  Future<NetworkResponse<RegimeType>> getDietType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegimeType>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/diet-type',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RegimeType>.fromJson(
      _result.data!,
      (json) => RegimeType.fromJson(json as Map<String, dynamic>),
=======
  Future<NetworkResponse<FoodListData>> foodList(date) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<FoodListData>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/user/menu?date=$date',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<FoodListData>.fromJson(
      _result.data!,
      (json) => FoodListData.fromJson(json as Map<String, dynamic>),
>>>>>>> develop
    );
    return value;
  }

  @override
<<<<<<< HEAD
  Future<NetworkResponse<Help>> helpDietType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Help>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/page/1',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Help>.fromJson(
      _result.data!,
      (json) => Help.fromJson(json as Map<String, dynamic>),
=======
  Future<NetworkResponse<UserInformation>> getProfile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/profile',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserInformation>.fromJson(
      _result.data!,
      (json) => UserInformation.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserInformation>> getPdfTermUrl() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/user/menu/all/pdf',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserInformation>.fromJson(
      _result.data!,
      (json) => UserInformation.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserInformation>> getPdfWeekUrl() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/user/menu/pdf',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserInformation>.fromJson(
      _result.data!,
      (json) => UserInformation.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<CityProvinceModel>> getProvinces() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CityProvinceModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/province',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CityProvinceModel>.fromJson(
      _result.data!,
      (json) => CityProvinceModel.fromJson(json as Map<String, dynamic>),
>>>>>>> develop
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
