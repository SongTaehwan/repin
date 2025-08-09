// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/provider/dto/repository.dto.dart';
import 'package:repin/app/data/repository/code_repo.interface.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

@LazySingleton(as: RepositoryServiceInterface)
class RepositorySearchService implements RepositoryServiceInterface {
  final CodeRepoRepositoryInterface _repository;

  RepositorySearchService(this._repository);

  @override
  Future<Either<Failure, List<Repository>>> searchRepositories(
    String query,
  ) async {
    // 복잡한 비즈니스 로직
    // 여러 Repository 호출
    // 데이터 검증 및 가공
    throw UnimplementedError();
  }
}
