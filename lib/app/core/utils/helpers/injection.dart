// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/api/api_client.dart';
import 'package:repin/app/core/utils/api/api_client.interface.dart';
import 'package:repin/app/core/utils/helpers/injection.config.dart';
import 'package:repin/app/data/provider/github.provider.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';

final GetIt getIt = GetIt.instance;

/// 의존성 주입을 위한 초기화
@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async {
  if (kDebugMode) {
    await getIt.reset();
  }

  try {
    // Hive 초기화
    await Hive.initFlutter();

    // GetIt 및 모듈 초기화 (preResolve 반영)
    await getIt.init();

    await registerSingletons();

    debugPrint('✅ 의존성 주입 초기화 완료');
  } catch (e) {
    debugPrint('❌ 의존성 주입 초기화 실패: $e');
    rethrow;
  }
}

Future<void> registerSingletons() async {
  // ApiClient 비동기 등록 및 초기화
  getIt.registerSingletonAsync<IApiClient>(() => ApiClient.create());
  final api = await getIt.getAsync<IApiClient>();

  // Github Provider 등록 (Retrofit 구현체)
  getIt.registerLazySingleton<GithubProviderInterface>(
    () => GithubProvider(api.client),
  );

  // 페이지 사이즈 상수 등록 (injection.config.dart 에서 pageSize 로 사용됨)
  if (!getIt.isRegistered<int>()) {
    getIt.registerLazySingleton<int>(() => 10);
  }
}
