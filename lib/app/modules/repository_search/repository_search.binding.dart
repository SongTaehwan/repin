// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/api/api_client.interface.dart';
import 'package:repin/app/core/utils/helpers/injection.dart';
import 'package:repin/app/data/provider/github.provider.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';
import 'package:repin/app/data/repository/code_repo.repository.dart';
import 'package:repin/app/data/repository/code_repo.repository.interface.dart';
import 'package:repin/app/data/services/repository_bookmark.service.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';
import 'package:repin/app/data/services/repository_search.service.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchBinding extends Bindings {
  @override
  void dependencies() {
    // Provider
    final provider = getIt<GithubProviderInterface>();

    // Repository
    Get.lazyPut<CodeRepoRepositoryInterface>(
      () => CodeRepoRepository(provider),
    );

    // Service
    Get.lazyPut<RepositoryServiceInterface>(
      () => RepositorySearchService(Get.find<CodeRepoRepositoryInterface>()),
    );

    // Bookmark Service
    Get.lazyPut<RepositoryBookmarkServiceInterface>(
      () => RepositoryBookmarkService(),
    );

    // Controller
    Get.lazyPut<RepositorySearchController>(
      () => RepositorySearchController(
        Get.find<RepositoryServiceInterface>(),
        Get.find<RepositoryBookmarkServiceInterface>(),
      ),
    );
  }
}
