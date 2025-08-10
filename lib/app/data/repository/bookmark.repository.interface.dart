// 📦 Package imports:
import 'package:fpdart/fpdart.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';

/// 북마크 영속성 접근을 담당하는 Repository 인터페이스
abstract class BookmarkRepositoryInterface {
  /// 해당 ID가 북마크되어 있는지 여부 반환
  Future<bool> isBookmarked(int repositoryId);

  /// 북마크 추가
  Future<Either<Failure, Unit>> addBookmark(Repository repository);

  /// 북마크 제거
  Future<Either<Failure, Unit>> removeBookmark(int repositoryId);

  /// 모든 북마크 ID 조회
  Future<Set<int>> getAllBookmarkedIds();

  /// 모든 북마크 레포지토리 조회
  Future<List<Repository>> getAllBookmarks();

  /// 가장 마지막에 추가된 북마크 1건 조회 (없으면 null)
  Future<Repository?> getLastAddedBookmark();
}
