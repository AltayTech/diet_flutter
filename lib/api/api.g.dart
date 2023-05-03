// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<NetworkResponse<List<Country>>> getCountries() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<List<Country>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/country',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<List<Country>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json
              .map<Country>((i) => Country.fromJson(i as Map<String, dynamic>))
              .toList()
          : List.empty(),
    );
    return value;
  }

  @override
  Future<NetworkResponse<CheckStatus>> checkUserStatus(String? mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CheckStatus>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/check-user-status?mobile=${mobile}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CheckStatus>.fromJson(
      _result.data!,
      (json) => CheckStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<SignIn>> signInWithPhoneNumber(User user) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<SignIn>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<SignIn>.fromJson(
      _result.data!,
      (json) => SignIn.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VerificationCode>> sendVerificationCode(
      String? mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerificationCode>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/send-verification-code?mobile=${mobile}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VerificationCode>.fromJson(
      _result.data!,
      (json) => VerificationCode.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VerifyOutput>> verifyUser(
      VerificationCode verificationCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(verificationCode.toJson());
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VerifyOutput>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/verify',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VerifyOutput>.fromJson(
      _result.data!,
      (json) => VerifyOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ResetOutput>> resetPassword(Reset password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(password.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ResetOutput>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/reset-password',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ResetOutput>.fromJson(
      _result.data!,
      (json) => ResetOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<RegisterOutput>> register(Register reg) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(reg.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegisterOutput>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RegisterOutput>.fromJson(
      _result.data!,
      (json) => RegisterOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<RegimeType>> getDietType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegimeType>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/diet-type',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RegimeType>.fromJson(
      _result.data!,
      (json) => RegimeType.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Help>> helpDietType(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Help>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/page/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Help>.fromJson(
      _result.data!,
      (json) => Help.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Help>> helpBodyState(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Help>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/field/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Help>.fromJson(
      _result.data!,
      (json) => Help.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> setCondition(
      Map<String, dynamic> requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/condition',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<PhysicalInfoData>> sendInfo(
      PhysicalInfoData info) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(info.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<PhysicalInfoData>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/physical-info',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<PhysicalInfoData>.fromJson(
      _result.data!,
      (json) => PhysicalInfoData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<BodyStatus>> getStatus() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<BodyStatus>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/body-status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<BodyStatus>.fromJson(
      _result.data!,
      (json) => BodyStatus.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<FoodListData>> foodList(String date) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<FoodListData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/menuappnew?date=${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<FoodListData>.fromJson(
      _result.data!,
      (json) => FoodListData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserInformation>> getProfile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/profile',
              queryParameters: queryParameters,
              data: _data,
            )
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
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/menu/all/pdf',
              queryParameters: queryParameters,
              data: _data,
            )
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
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/menu/pdf',
              queryParameters: queryParameters,
              data: _data,
            )
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
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CityProvinceModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/province',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CityProvinceModel>.fromJson(
      _result.data!,
      (json) => CityProvinceModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Media>> sendMedia(
    File media,
    String info,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'media',
      MultipartFile.fromFileSync(
        media.path,
        filename: media.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'info',
      info,
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Media>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/media',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Media>.fromJson(
      _result.data!,
      (json) => Media.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserInformation>> updateProfile(
      UserInformationEdit userInformation) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userInformation.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserInformation>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/profile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserInformation>.fromJson(
      _result.data!,
      (json) => UserInformation.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Inbox>> getUnreadInbox() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Inbox>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/inbox/unseen/count',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Inbox>.fromJson(
      _result.data!,
      (json) => Inbox.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Inbox>> getInbox() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Inbox>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/inbox',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Inbox>.fromJson(
      _result.data!,
      (json) => Inbox.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<TicketModel>> getTicketMessage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<TicketModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<TicketModel>.fromJson(
      _result.data!,
      (json) => TicketModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<List<FastPatternData>>> fastPattern() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<List<FastPatternData>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/fasting-pattern',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<List<FastPatternData>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json
              .map<FastPatternData>(
                  (i) => FastPatternData.fromJson(i as Map<String, dynamic>))
              .toList()
          : List.empty(),
    );
    return value;
  }

  @override
  Future<NetworkResponse<FastMenuRequestData>> changeToFast(
      FastMenuRequestData requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<FastMenuRequestData>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-fasting-log',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<FastMenuRequestData>.fromJson(
      _result.data!,
      (json) => FastMenuRequestData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ListFoodData>> listFood(String filter) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ListFoodData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/food?filter=${filter}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ListFoodData>.fromJson(
      _result.data!,
      (json) => ListFoodData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<bool>> dailyMenu(DailyMenuRequestData date) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(date.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<bool>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/menu',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<bool>.fromJson(
      _result.data!,
      (json) => json as bool,
    );
    return value;
  }

  @override
  Future<NetworkResponse<CalendarData>> calendar(
    String start,
    String end,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CalendarData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/calendar?start_date=${start}&end_date=${end}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CalendarData>.fromJson(
      _result.data!,
      (json) => CalendarData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<SupportModel>> getDepartmentItems() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<SupportModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/department',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<SupportModel>.fromJson(
      _result.data!,
      (json) => SupportModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> sendTicketMessage(
      SendTicket sendTicket) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendTicket.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> sendTicketMessageDetail(
      SendTicket sendTicket) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(sendTicket.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/message',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> sendTicketFile(
    File media,
    int is_voice,
    int has_attachment,
    String department_id,
    String title,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'media',
      MultipartFile.fromFileSync(
        media.path,
        filename: media.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'is_voice',
      is_voice.toString(),
    ));
    _data.fields.add(MapEntry(
      'has_attachment',
      has_attachment.toString(),
    ));
    _data.fields.add(MapEntry(
      'department_id',
      department_id,
    ));
    _data.fields.add(MapEntry(
      'title',
      title,
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> sendTicketFileDetail({
    File? media,
    int? is_voice,
    int? ticket_id,
    String? body,
    int? has_attachment,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (media != null) {
      _data.files.add(MapEntry(
        'media',
        MultipartFile.fromFileSync(
          media.path,
          filename: media.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (is_voice != null) {
      _data.fields.add(MapEntry(
        'is_voice',
        is_voice.toString(),
      ));
    }
    if (ticket_id != null) {
      _data.fields.add(MapEntry(
        'ticket_id',
        ticket_id.toString(),
      ));
    }
    if (body != null) {
      _data.fields.add(MapEntry(
        'body',
        body,
      ));
    }
    if (has_attachment != null) {
      _data.fields.add(MapEntry(
        'has_attachment',
        has_attachment.toString(),
      ));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/message',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<TicketModel>> getTicketDetails(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<TicketModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/ticket/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<TicketModel>.fromJson(
      _result.data!,
      (json) => TicketModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Call>> getCallItems() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Call>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/calls',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Call>.fromJson(
      _result.data!,
      (json) => Call.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> sendCall() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/calls',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> deleteCall(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/calls/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<CalenderOutput>> getCalendar(
    String? startDate,
    String? endDate,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CalenderOutput>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/psychology/v2/dates/list?start_date=${startDate}&end_date=${endDate}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CalenderOutput>.fromJson(
      _result.data!,
      (json) => CalenderOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<PhysicalInfoData>> physicalInfo() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<PhysicalInfoData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/physical-info',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<PhysicalInfoData>.fromJson(
      _result.data!,
      (json) => PhysicalInfoData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserSickness>> getUserSickness() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserSickness>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-sickness',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserSickness>.fromJson(
      _result.data!,
      (json) => UserSickness.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> setUserSickness(
      UserSickness userSickness) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userSickness.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-sickness',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserSicknessSpecial>> getUserSicknessSpecial() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserSicknessSpecial>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-special',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserSicknessSpecial>.fromJson(
      _result.data!,
      (json) => UserSicknessSpecial.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> setUserSicknessSpecial(
      UserSickness userSickness) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userSickness.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-special',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<AdviceData>> advice() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<AdviceData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user-recommend',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<AdviceData>.fromJson(
      _result.data!,
      (json) => AdviceData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<PackageItem>> getPackages() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<PackageItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/package',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<PackageItem>.fromJson(
      _result.data!,
      (json) => PackageItem.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<PackageItem>> getPackageUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<PackageItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/package',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<PackageItem>.fromJson(
      _result.data!,
      (json) => PackageItem.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Price?>> checkCoupon(Price price) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(price.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Price>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/check-coupon',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Price?>.fromJson(
      _result.data!,
      (json) =>
          json == null ? null : Price.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Payment>> selectPayment(Payment payment) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(payment.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Payment>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/payment',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Payment>.fromJson(
      _result.data!,
      (json) => Payment.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> nextStep() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/next-step',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<LatestInvoiceData>> latestInvoice() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<LatestInvoiceData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/latest-invoice',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<LatestInvoiceData>.fromJson(
      _result.data!,
      (json) => LatestInvoiceData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<LatestInvoiceData>> newPayment(
      LatestInvoiceData requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<LatestInvoiceData>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/latest-invoice',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<LatestInvoiceData>.fromJson(
      _result.data!,
      (json) => LatestInvoiceData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<BookingOutput>> getBook(Booking booking) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(booking.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<BookingOutput>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/psychology/v2/booking',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<BookingOutput>.fromJson(
      _result.data!,
      (json) => BookingOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<HistoryOutput>> getHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<HistoryOutput>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/psychology/v2/booking-histories',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<HistoryOutput>.fromJson(
      _result.data!,
      (json) => HistoryOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<LatestInvoiceData>> getInvoice() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<LatestInvoiceData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/psychology/latest-invoice',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<LatestInvoiceData>.fromJson(
      _result.data!,
      (json) => LatestInvoiceData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ActivityLevelData>> activityLevel() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ActivityLevelData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/activity-level',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ActivityLevelData>.fromJson(
      _result.data!,
      (json) => ActivityLevelData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<DietHistoryData>> dietHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<DietHistoryData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/diet-history',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<DietHistoryData>.fromJson(
      _result.data!,
      (json) => DietHistoryData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<DietGoalData>> dietGoals() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<DietGoalData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/diet-goal',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<DietGoalData>.fromJson(
      _result.data!,
      (json) => DietGoalData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<OverviewData>> overview() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<OverviewData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/condition',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<OverviewData>.fromJson(
      _result.data!,
      (json) => OverviewData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<VisitItem>> visits() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VisitItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/visits',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VisitItem>.fromJson(
      _result.data!,
      (json) => VisitItem.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<MenuData>> menuType() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<MenuData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/menu-type?is_user=1',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<MenuData>.fromJson(
      _result.data!,
      (json) => MenuData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Term>> term() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Term>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/term',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Term>.fromJson(
      _result.data!,
      (json) => Term.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> menuSelect(
      ConditionRequestData conditionRequestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(conditionRequestData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/menu-select',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> visit(
      Map<String, dynamic> requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/visit',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<VersionData>> getVersion() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<VersionData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/check-version',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<VersionData>.fromJson(
      _result.data!,
      (json) => VersionData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Fitamin>> checkFitamin() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Fitamin>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/fitamin-url',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Fitamin>.fromJson(
      _result.data!,
      (json) => Fitamin.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<RegisterOutput>> landingReg(Register reg) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(reg.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RegisterOutput>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RegisterOutput>.fromJson(
      _result.data!,
      (json) => RegisterOutput.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ShopModel>> getHomeShop() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ShopModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/homepage',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ShopModel>.fromJson(
      _result.data!,
      (json) => ShopModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ShopCategory>> getCategory(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ShopCategory>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/categories/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ShopCategory>.fromJson(
      _result.data!,
      (json) => ShopCategory.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Orders>> getOrders() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Orders>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/orders',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Orders>.fromJson(
      _result.data!,
      (json) => Orders.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ShopProduct>> getProduct(int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ShopProduct>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/products/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ShopProduct>.fromJson(
      _result.data!,
      (json) => ShopProduct.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<TermPackage>> getTermPackage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<TermPackage>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/term-package',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<TermPackage>.fromJson(
      _result.data!,
      (json) => TermPackage.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<RefundItem>> getRefund() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<RefundItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/refund',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<RefundItem>.fromJson(
      _result.data!,
      (json) => RefundItem.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> editVisit(
      PhysicalInfoData requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/visit',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> verifyPassword(String? mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/auth?password=${mobile}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<dynamic>> setRefund(RefundVerify refundVerify) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(refundVerify.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/refund',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  }

  @override
  Future<NetworkResponse<Payment>> shopOnlinePayment(
      Payment requestData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(requestData.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Payment>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/payment-shop',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Payment>.fromJson(
      _result.data!,
      (json) => Payment.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<LatestInvoiceData>> shopLastInvoice() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<LatestInvoiceData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/latest-shop-invoice',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<LatestInvoiceData>.fromJson(
      _result.data!,
      (json) => LatestInvoiceData.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<ShopCategory>> getProducts(String filter) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<ShopCategory>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/products?filter=${filter}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<ShopCategory>.fromJson(
      _result.data!,
      (json) => ShopCategory.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<Price?>> checkCouponShop(Price price) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(price.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<Price>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/check-coupon-shop',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<Price?>.fromJson(
      _result.data!,
      (json) =>
          json == null ? null : Price.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<CallSupport>> getCallSupport() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<CallSupport>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/user/support-expert',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<CallSupport>.fromJson(
      _result.data!,
      (json) => CallSupport.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<NetworkResponse<UserCrmResponse>> sendUserToCrm(
      UserCrm userCrm) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userCrm.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NetworkResponse<UserCrmResponse>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/land-data',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NetworkResponse<UserCrmResponse>.fromJson(
      _result.data!,
      (json) => UserCrmResponse.fromJson(json as Map<String, dynamic>),
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
