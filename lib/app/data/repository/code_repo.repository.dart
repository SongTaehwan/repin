// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';
import 'package:repin/app/data/repository/code_repo.interface.dart';

// 역할 - 데이터 소스 접근 추상화
// 1. 데이터 소스 에러 → 도메인 에러로 맵핑
// 2. DTO → 도메인 모델 매핑
// 3. 캐싱

@LazySingleton(as: CodeRepoRepositoryInterface)
class CodeRepoRepository implements CodeRepoRepositoryInterface {
  final GithubProviderInterface _api;

  CodeRepoRepository(this._api);

  // TODO: Local or remote data source
  @override
  Future<Either<Failure, Future<SearchRepositories>>> searchRepositories(
    String query,
  ) async {
    return Either.tryCatch(
      () => _api.searchRepositories(query),
      (error, stackTrace) => Failure.unexpected(error.toString()),
    );
  }
}
