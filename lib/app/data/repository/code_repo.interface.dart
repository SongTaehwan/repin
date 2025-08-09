// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';

abstract class CodeRepoRepositoryInterface {
  Future<Either<Failure, Future<SearchRepositories>>> searchRepositories(
    String query,
  );
}
