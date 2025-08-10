// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';

abstract class RepositoryServiceInterface {
  // 추가 페이지 존재 여부 확인을 위한 플래그
  bool get hasMore;

  Future<Either<Failure, (List<Repository>, int)>> loadFirst(String query);

  Future<Either<Failure, (List<Repository>, int)>> loadNext(String query);
}
