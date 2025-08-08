// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/api/api_client.dart';
import 'package:repin/app/core/utils/helpers/injection.config.dart';

final GetIt getIt = GetIt.instance;

/// 의존성 주입을 위한 초기화
@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies() async {
  await Hive.initFlutter();
  await getIt.getAsync<ApiClient>();
  getIt.init();
}
