// 페이지 참조를 이 위젯 내부로 캡슐화하여 View/Controller의 직접 참조를 제거함

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/shared/debug/route_stack_observer.dart';

class NestedRouter extends StatelessWidget {
  const NestedRouter({
    super.key,
    required this.routes,
    required this.navigatorId,
    required this.parentRoute,
    required this.initialRoute,
  });

  // 앱 라우트 목록
  final List<GetPage> routes;

  // 중첩 네비게이터 id
  final int navigatorId;

  // 부모 라우트(앵커) 이름 (예: Routes.ENTRY)
  final String parentRoute;

  // 초기 자식 라우트 이름 (예: Routes.REPOSITORY_SEARCH)
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: kDebugMode
          ? [RouteStackObserver.child(navigatorId)]
          : const [],
      // NOTE: 중첩 네비게이터를 위해 고유 키 사용
      key: Get.nestedKey(navigatorId),
      initialRoute: initialRoute,
      // NOTE: 자식 라우트 생성을 라우팅 그래프에 위임
      onGenerateRoute: (settings) {
        final child = _findChildOf(parentRoute, settings.name);

        // 자식 라우트가 없으면 초기 라우트로 리다이렉트
        if (child == null) {
          final fallback = _findChildOf(parentRoute, initialRoute);

          if (fallback == null) {
            return null;
          }

          return GetPageRoute(
            settings: settings,
            page: fallback.page,
            binding: fallback.binding,
            middlewares: fallback.middlewares,
          );
        }

        return GetPageRoute(
          settings: settings,
          page: child.page,
          binding: child.binding,
          middlewares: child.middlewares,
        );
      },
    );
  }

  // NOTE: 부모 라우트 하위 children에서 이름으로 자식 페이지 찾기
  GetPage<dynamic>? _findChildOf(String parent, String? childName) {
    if (childName == null) {
      return null;
    }

    return routes
        // 부모 페이지 찾기
        .where((page) => page.name == parent)
        .firstOrNull
        ?.children
        // 자식 페이지 찾기
        .where((page) => page.name == childName)
        .firstOrNull;
  }
}
