// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'license.dto.freezed.dart';
part 'license.dto.g.dart';

@freezed
abstract class License with _$License {
  const factory License({
    @JsonKey(name: "html_url") String? htmlUrl,
    @JsonKey(name: "key") required String key,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "node_id") required String nodeId,
    @JsonKey(name: "spdx_id") required String? spdxId,
    @JsonKey(name: "url") required String? url,
  }) = _License;

  factory License.fromJson(Map<String, Object?> json) =>
      _$LicenseFromJson(json);
}
