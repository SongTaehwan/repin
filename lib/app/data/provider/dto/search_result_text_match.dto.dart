// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_text_match.dto.freezed.dart';
part 'search_result_text_match.dto.g.dart';

@freezed
abstract class SearchResultTextMatch with _$SearchResultTextMatch {
  const factory SearchResultTextMatch({
    @JsonKey(name: "fragment") String? fragment,
    @JsonKey(name: "matches") List<Match>? matches,
    @JsonKey(name: "object_type") String? objectType,
    @JsonKey(name: "object_url") String? objectUrl,
    @JsonKey(name: "property") String? property,
  }) = _SearchResultTextMatch;

  factory SearchResultTextMatch.fromJson(Map<String, dynamic> json) =>
      _$SearchResultTextMatchFromJson(json);
}

@freezed
abstract class Match with _$Match {
  const factory Match({
    @JsonKey(name: "indices") List<int>? indices,
    @JsonKey(name: "text") String? text,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}
