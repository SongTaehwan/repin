// 🐦 Flutter imports:
import 'package:flutter/widgets.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/app_container/app_container.binding.dart';
import 'package:repin/app/modules/app_container/app_container.view.dart';
import 'package:repin/app/modules/repository_bookmark/repository_bookmark.binding.dart';
import 'package:repin/app/modules/repository_bookmark/repository_bookmark.view.dart';
import 'package:repin/app/modules/repository_search/repository_search.binding.dart';
import 'package:repin/app/modules/repository_search/repository_search.view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ENTRY;

  static final routes = [
    GetPage(
      name: Routes.ENTRY,
      page: () => AppContainerView(),
      binding: AppContainerBinding(),
      children: [
        GetPage(
          name: Routes.REPOSITORY_SEARCH,
          page: () =>
              const PopScope(canPop: false, child: RepositorySearchView()),
          binding: RepositorySearchBinding(),
        ),
        GetPage(
          name: Routes.REPOSITORY_BOOKMARK,
          page: () =>
              const PopScope(canPop: false, child: RepositoryBookmarkView()),
          binding: RepositoryBookmarkBinding(),
        ),
      ],
    ),
  ];
}
