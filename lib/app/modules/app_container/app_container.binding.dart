// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/app_container/app_container.controller.dart';

class AppContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppContainerController>(() => AppContainerController());
  }
}
