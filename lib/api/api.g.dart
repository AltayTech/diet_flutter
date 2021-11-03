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
  Future<NetworkResponse<List<Country>>> getCountries() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<List<Country>>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/country',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<List<Country>>.fromJson(
        _result.data!,
        (json) => (json as List<dynamic>)
            .map<Country>((i) => Country.fromJson(i as Map<String, dynamic>))
            .toList());
    return value;
  }

  @override
  Future<NetworkResponse<CheckStatus>> checkUserStatus(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CheckStatus>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
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
  Future<NetworkResponse<VerificationCode>> sendVerificationCode(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(mobile.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerificationCode>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/send-verification-code',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VerificationCode>.fromJson(
      _result.data!,
      (json) => VerificationCode.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VerifyOutput>> verifyUser(code) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(code.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerifyOutput>>(Options(
                method: 'PATCH', headers: <String, dynamic>{}, extra: _extra)
            .compose(_dio.options, '/verify',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
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
    final _data = <String, dynamic>{};
    _data.addAll(password.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ResetOutput>>(Options(
                method: 'PATCH', headers: <String, dynamic>{}, extra: _extra)
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
    final _data = <String, dynamic>{};
    _data.addAll(mobile.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegisterOutput>>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
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
  Future<NetworkResponse<FoodListData>> foodList(date) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<FoodListData>>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/user/menu?date=$date',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<FoodListData>.fromJson(
      _result.data!,
      (json) => FoodListData.fromJson(json as Map<String, dynamic>),
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
