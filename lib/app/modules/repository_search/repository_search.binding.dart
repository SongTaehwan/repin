// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RepositorySearchController>(() => RepositorySearchController());
  }
}
