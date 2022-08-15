import 'package:json_annotation/json_annotation.dart';

enum boolean {
  @JsonValue(0)
  False,
  @JsonValue(1)
  True,
}