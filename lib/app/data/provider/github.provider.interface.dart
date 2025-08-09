// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';

abstract class GithubProviderInterface {
  Future<SearchRepositories> searchRepositories(
    String query, {
    String sort,
    String order,
    int perPage,
    int page,
  });
}
