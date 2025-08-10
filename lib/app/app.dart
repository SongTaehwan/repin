// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/debug/route_stack_observer.dart';
import 'package:repin/app/routes/app_pages.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      smartManagement: SmartManagement.full,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorObservers: kDebugMode ? [RouteStackObserver.root()] : const [],
    );
  }
}
