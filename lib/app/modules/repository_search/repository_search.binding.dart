// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/api/api_client.interface.dart';
import 'package:repin/app/core/utils/helpers/injection.dart';
import 'package:repin/app/data/provider/github.provider.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';
import 'package:repin/app/data/repository/code_repo.interface.dart';
import 'package:repin/app/data/repository/code_repo.repository.dart';
import 'package:repin/app/data/services/repository_search.service.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchBinding extends Bindings {
  @override
  void dependencies() {
    // Provider
    final dio = getIt<IApiClient>().client;
    Get.lazyPut<GithubProviderInterface>(() => GithubProvider(dio));

    // Repository
    Get.lazyPut<CodeRepoRepositoryInterface>(
      () => CodeRepoRepository(Get.find<GithubProviderInterface>()),
    );

    // Service
    Get.lazyPut<RepositoryServiceInterface>(
      () => RepositorySearchService(Get.find<CodeRepoRepositoryInterface>()),
    );

    // Controller
    Get.lazyPut<RepositorySearchController>(
      () => RepositorySearchController(Get.find<RepositoryServiceInterface>()),
    );
  }
}
