// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/repository/code_repo.repository.interface.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

// 복잡한 비즈니스 로직
// 여러 Repository 호출
// 데이터 검증 및 가공
@LazySingleton(as: RepositoryServiceInterface)
class RepositorySearchService implements RepositoryServiceInterface {
  final CodeRepoRepositoryInterface _repository;

  RepositorySearchService(this._repository);

  bool get hasMore => _repository.hasMore;

  @override
  Future<Either<Failure, Future<(List<Repository>, int)>>> loadFirst(
    String query,
  ) async {
    _repository.reset();
    return await _repository.fetchFirstPage(query);
  }

  @override
  Future<Either<Failure, Future<(List<Repository>, int)>>> loadNext(
    String query,
  ) async {
    return await _repository.fetchNextPage(query);
  }
}
