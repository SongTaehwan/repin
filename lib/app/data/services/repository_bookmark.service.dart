// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/repository/bookmark.repository.interface.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';

/// 북마크 서비스: 비즈니스 로직(정책, 정렬 등) 담당
@LazySingleton(as: RepositoryBookmarkServiceInterface)
class RepositoryBookmarkService implements RepositoryBookmarkServiceInterface {
  final BookmarkRepositoryInterface _repository;

  RepositoryBookmarkService(this._repository);

  @override
  Future<bool> isBookmarked(int repositoryId) async {
    return _repository.isBookmarked(repositoryId);
  }

  @override
  Future<Either<Failure, Unit>> addBookmark(Repository repository) async {
    return _repository.addBookmark(repository);
  }

  @override
  Future<Either<Failure, Unit>> removeBookmark(int repositoryId) async {
    return _repository.removeBookmark(repositoryId);
  }

  @override
  Future<Set<int>> getAllBookmarkedIds() async {
    return _repository.getAllBookmarkedIds();
  }

  @override
  Future<List<Repository>> getAllBookmarks() async {
    final items = await _repository.getAllBookmarks();
    // 정책: 최신 업데이트 순 정렬은 서비스층에서 수행
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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
