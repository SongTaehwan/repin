// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions.dto.freezed.dart';
part 'permissions.dto.g.dart';

@freezed
abstract class Permissions with _$Permissions {
  const factory Permissions({
    @JsonKey(name: "admin") required bool admin,
    @JsonKey(name: "maintain") bool? maintain,
    @JsonKey(name: "pull") required bool pull,
    @JsonKey(name: "push") required bool push,
    @JsonKey(name: "triage") bool? triage,
  }) = _Permissions;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);
}
