// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/helpers/injection.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchBinding extends Bindings {
  @override
  void dependencies() {
    // Service 객체는 get_it 으로 생성된 싱글톤 객체를 사용
    // 필요에 따라 직접 생성하여 사용할 수 있음
    Get.lazyPut<RepositorySearchServiceInterface>(
      () => getIt<RepositorySearchServiceInterface>(),
    );

    Get.lazyPut<RepositoryBookmarkServiceInterface>(
      () => getIt<RepositoryBookmarkServiceInterface>(),
    );

    // Controller
    Get.lazyPut<RepositorySearchController>(
      () => RepositorySearchController(
        Get.find<RepositorySearchServiceInterface>(),
        Get.find<RepositoryBookmarkServiceInterface>(),
      ),
    );
  }
}
