// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/app_container/app_container.controller.dart';
import 'package:repin/app/modules/app_container/widgets/nested_router.dart';
import 'package:repin/app/routes/app_pages.dart';

class AppContainerView extends GetView<AppContainerController> {
  const AppContainerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NOTE: 하단 네비게이션은 항상 유지되어야 함
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTapItem,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '북마크'),
          ],
        ),
      ),
      body: NestedRouter(
        routes: AppPages.routes,
        navigatorId: 1,
        parentRoute: Routes.ENTRY,
        initialRoute: Routes.REPOSITORY_SEARCH,
      ),
    );
  }
}
