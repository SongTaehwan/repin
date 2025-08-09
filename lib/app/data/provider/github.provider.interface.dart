// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';

abstract class GithubProviderInterface {
  Future<SearchRepositories> searchRepositories(String query);
}
