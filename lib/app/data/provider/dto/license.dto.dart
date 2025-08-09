// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'license.dto.freezed.dart';
part 'license.dto.g.dart';

@freezed
abstract class License with _$License {
  const factory License({
    required String key,
    required String name,
    required String spdxId,
    required String url,
    required String nodeId,
  }) = _License;

  factory License.fromJson(Map<String, Object?> json) =>
      _$LicenseFromJson(json);
}
