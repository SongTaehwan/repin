// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';

abstract class RepositoryServiceInterface {
  Future<Either<Failure, Future<(List<Repository>, int)>>> loadFirst(
    String query,
  );

  Future<Either<Failure, Future<(List<Repository>, int)>>> loadNext(
    String query,
  );
}
