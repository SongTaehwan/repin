// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/constant/hive_keys.dart';
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/repository/bookmark.repository.interface.dart';

/// Hive 기반 북마크 Repository 구현체
@LazySingleton(as: BookmarkRepositoryInterface)
class BookmarkRepository implements BookmarkRepositoryInterface {
  /// 내부 Box 오픈 함수 (필요시 lazy 캐싱 고려)
  Future<Box> _openBox() => Hive.openBox(HIVE_BOX_BOOKMARKS);

  @override
  Future<bool> isBookmarked(int repositoryId) async {
    final box = await _openBox();
    return box.containsKey(repositoryId);
  }

  @override
  Future<Either<Failure, Unit>> addBookmark(Repository repository) async {
    try {
      final box = await _openBox();
      await box.put(repository.id, repository.toJson());
      return right(unit);
    } catch (e) {
      return left(Failure.unexpected('즐겨찾기 추가 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeBookmark(int repositoryId) async {
    try {
      final box = await _openBox();
      await box.delete(repositoryId);
      return right(unit);
    } catch (e) {
      return left(Failure.unexpected('즐겨찾기 제거 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Set<int>> getAllBookmarkedIds() async {
    final box = await _openBox();
    return box.keys.whereType<int>().toSet();
  }

  @override
  Future<List<Repository>> getAllBookmarks() async {
    final box = await _openBox();
    final List<Repository> items = [];
    for (final key in box.keys) {
      final value = box.get(key);
      if (value is Map) {
        try {
          items.add(Repository.fromJson(Map<String, dynamic>.from(value)));
        } catch (_) {
          // 무시: 잘못된 엔트리
        }
      }
    }
    return items;
  }

  @override
  Future<Repository?> getLastAddedBookmark() async {
    final items = await getAllBookmarks();
    if (items.isEmpty) return null;
    return items.first;
  }
}
