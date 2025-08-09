// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/repository.dto.dart';

part 'search_repositories.dto.freezed.dart';
part 'search_repositories.dto.g.dart';

@freezed
abstract class SearchRepositories with _$SearchRepositories {
  const factory SearchRepositories({
    @JsonKey(name: "total_count") required int totalCount,
    @JsonKey(name: "incomplete_results") required bool incompleteResults,
    @JsonKey(name: "items") required List<Repository> items,
  }) = _SearchRepositories;

  factory SearchRepositories.fromJson(Map<String, dynamic> json) =>
      _$SearchRepositoriesFromJson(json);
}
