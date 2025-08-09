// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';

part 'github.provider.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class GithubProvider {
  factory GithubProvider(Dio dio) = _GithubProvider;

  @GET('/search/repositories')
  Future<SearchRepositories> searchRepositories(@Query("q") String query);
}
