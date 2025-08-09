// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';

abstract class CodeRepoRepositoryInterface {
  bool get hasMore;

  void reset();

  Future<Either<Failure, Future<(List<Repository>, int)>>> fetchFirstPage(
    String query,
  );

  Future<Either<Failure, Future<(List<Repository>, int)>>> fetchNextPage(
    String query, {
    int page = 1,
    int limit = 10,
  });
}
