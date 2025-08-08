// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// 🌎 Project imports:
import 'package:repin/app/data/model/search_repositories.dart';

part 'api.provider.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class ApiProvider {
  factory ApiProvider(Dio dio) = _ApiProvider;

  @GET('/search/repositories')
  Future<SearchRepositories> searchRepositories(@Query("q") String query);
}
