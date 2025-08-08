// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ErrorSource {
  // Flutter 프레임워크 레벨 에러
  framework,
  // 엔진/플랫폼 디스패처 레벨 에러
  engine,
  // 애플리케이션 레벨 비동기 미처리 예외
  app,
}

// 전역 에러 처리 공통 핸들러
void handleGlobalError(
  ErrorSource source,
  Object error,
  StackTrace? stack, {
  FlutterErrorDetails? details,
}) {
  // NOTE: 로깅/전송 등 처리 (Crashlytics/Sentry 등)
  debugPrint('[${source.name}] Uncaught error: ${error.toString()}');
  debugPrint('[${source.name}] Stack trace: ${stack.toString()}');
}

// 전역 비동기 미처리 예외 처리 지점
void catchUnhandleExceptions(Object error, StackTrace? stack) {
  // 애플리케이션 레벨 비동기 미처리 예외 처리
  handleGlobalError(ErrorSource.app, error, stack);
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter 프레임워크 레벨 에러 처리
  FlutterError.onError = (FlutterErrorDetails details) {
    handleGlobalError(
      ErrorSource.framework,
      details.exception,
      details.stack ?? StackTrace.empty,
      details: details,
    );
  };

  // 엔진/플랫폼 디스패처 레벨 에러 처리
  WidgetsBinding.instance.platformDispatcher.onError =
      (Object error, StackTrace stack) {
        handleGlobalError(ErrorSource.engine, error, stack);
        // true 반환 시 에러가 처리된 것으로 간주되어 상위로 전파되지 않음
        return true;
      };

  await runZonedGuarded(() async {
    // 세로 방향만 허용
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO: 의존성, SDK 등 초기화 작업 추가
    runApp(await builder());
  }, catchUnhandleExceptions);
}
