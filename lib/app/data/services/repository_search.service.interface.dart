// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/provider/dto/repository.dto.dart';

abstract class RepositoryServiceInterface {
  Future<Either<Failure, List<Repository>>> searchRepositories(String query);
}
