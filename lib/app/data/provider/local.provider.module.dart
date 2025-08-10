// lib/app/core/utils/helpers/hive_module.dart

// 📦 Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/constant/hive_keys.dart';

/// 로컬 저장소를 한곳에 모아두는 모듈로 get_it 에 등록되어 앱 전역에서 사용됩니다.
@module
abstract class LocalProviderModule {
  // 북마크 Hive Box 등록 (앱 전역 싱글톤)
  @preResolve
  @Named(HIVE_BOX_BOOKMARKS)
  Future<Box> bookmarksBox() => Hive.openBox(HIVE_BOX_BOOKMARKS);

  // TODO: User Preference Hive Box 등 추가
}
