// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_bookmark/repository_bookmark.controller.dart';

class RepositoryBookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RepositoryBookmarkController>(
      () => RepositoryBookmarkController(),
    );
  }
}
