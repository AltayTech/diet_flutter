import 'package:json_annotation/json_annotation.dart';

part 'network_response.g.dart';

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class NetworkResponse<T> {
  NetworkResponse();

  @JsonKey(name: "error")
  ErrorResponse? error;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "next")
  String? next;

  @JsonKey(name: "remaining_time")
  String? remainingTime;

  @JsonKey(name: "data")
  T? data;

  T get requireData => data!;

  factory NetworkResponse.withData(T? data) {
    return NetworkResponse()..data = data;
  }

  factory NetworkResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return _$NetworkResponseFromJson<T>(json, fromJsonT);
  }

}

@JsonSerializable()
class ErrorResponse {
  ErrorResponse();

  @JsonKey(name: "message")
  String? message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return _$ErrorResponseFromJson(json);
  }

}