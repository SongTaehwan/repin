// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/repository.dto.dart' as dto;

part 'repository.model.freezed.dart';
part 'repository.model.g.dart';

@freezed
abstract class Repository with _$Repository {
  const factory Repository({
    required int id,
    required String name,
    required String ownerName,
    required int ownerId,
    required String? ownerProfileUrl,
    required String repositoryUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime pushedAt,
    required int forksCount,
    required int openIssuesCount,
    required int stargazersCount,
    required int watchersCount,
    required String? license,
    required String? language,
    required String description,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);

  factory Repository.fromDto(dto.Repository dto) {
    return Repository(
      id: dto.id,
      name: dto.fullName,
      ownerName: dto.owner?.login ?? "deleted user",
      ownerId: dto.owner?.id ?? -1,
      ownerProfileUrl: dto.owner?.avatarUrl,
      repositoryUrl: dto.htmlUrl,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      pushedAt: dto.pushedAt,
      forksCount: dto.forksCount,
      openIssuesCount: dto.openIssuesCount,
      stargazersCount: dto.stargazersCount,
      watchersCount: dto.watchersCount,
      license: dto.license?.name,
      language: dto.language,
      description: dto.description ?? "",
    );
  }
}
