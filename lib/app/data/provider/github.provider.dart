// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/search_repositories.dto.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';

part 'github.provider.g.dart';

@RestApi(baseUrl: 'https://api.github.com/')
abstract class GithubProvider implements GithubProviderInterface {
  factory GithubProvider(Dio dio) = _GithubProvider;

  @override
  @GET('/search/repositories')
  Future<SearchRepositories> searchRepositories(
    @Query("q") String query, {
    @Query("sort") String sort = "stars",
    @Query("order") String order = "desc",
    @Query("per_page") int perPage = 10,
    @Query("page") int page = 1,
  });
}
