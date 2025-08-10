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
  try {
    // Hive 초기화
    await Hive.initFlutter();

    // GetIt 초기화
    getIt.init();

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

  getIt.registerLazySingleton<GithubProviderInterface>(
    () => GithubProvider(api.client),
  );
}
