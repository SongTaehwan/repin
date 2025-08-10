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
  /// get_it으로 관리되는 Hive Box 참조
  final Box _box;

  BookmarkRepository(@Named(HIVE_BOX_BOOKMARKS) this._box);

  @override
  Future<bool> isBookmarked(int repositoryId) async {
    return _box.containsKey(repositoryId);
  }

  @override
  Future<Either<Failure, Unit>> addBookmark(Repository repository) async {
    return TaskEither.tryCatch(
      () async {
        await _box.put(repository.id, repository.toJson());
        return unit;
      },
      (error, stackTrace) =>
          Failure.unexpected('즐겨찾기 추가 실패: ${error.toString()}'),
    ).run();
  }

  @override
  Future<Either<Failure, Unit>> removeBookmark(int repositoryId) async {
    return TaskEither.tryCatch(
      () async {
        await _box.delete(repositoryId);
        return unit;
      },
      (error, stackTrace) =>
          Failure.unexpected('즐겨찾기 제거 실패: ${error.toString()}'),
    ).run();
  }

  @override
  Future<Set<int>> getAllBookmarkedIds() async {
    return _box.keys.whereType<int>().toSet();
  }

  @override
  Future<List<Repository>> getAllBookmarks() async {
    final List<Repository> items = [];

    for (final key in _box.keys) {
      final value = _box.get(key);

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

    if (items.isEmpty) {
      return null;
    }

    return items.first;
  }
}
