// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';

abstract class CodeRepoRepositoryInterface {
  int? get nextPage;

  void reset();

  Future<Either<Failure, (List<Repository>, int)>> fetchFirstPage(String query);

  Future<Either<Failure, (List<Repository>, int)>> fetchNextPage(String query);
}
