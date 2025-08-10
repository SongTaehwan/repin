// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/app_container/app_container.controller.dart';

class AppContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppContainerController>(
      () => AppContainerController(),
      // 라우트 이동으로 제거 후 다시 화면으로 돌아올 때 자동 복원
      fenix: true,
    );
  }
}
