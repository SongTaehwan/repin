// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/helpers/widget_sync.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';

/// 북마크 화면 컨트롤러
class RepositoryBookmarkController extends GetxController {
  /// 의존성
  final RepositoryBookmarkServiceInterface _bookmarkService;

  /// 상태
  final RxList<Repository> bookmarks = <Repository>[].obs;

  RepositoryBookmarkController(this._bookmarkService);

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  /// 전체 북마크 로드
  Future<void> loadBookmarks() async {
    final items = await _bookmarkService.getAllBookmarks();
    bookmarks.assignAll(items);

    // 위젯 동기화: 가장 마지막 북마크를 위젯에 반영
    final last = await _bookmarkService.getLastAddedBookmark();
    await WidgetSync.syncLastBookmark(last);
  }

  /// 북마크 해제
  Future<void> unbookmark(Repository repository) async {
    final result = await _bookmarkService.removeBookmark(repository.id);

    result.fold(
      (failure) => Get.snackbar(
        '해제 실패',
        failure.toString(),
        snackPosition: SnackPosition.BOTTOM,
      ),
      (_) {
        bookmarks.removeWhere((e) => e.id == repository.id);
        Get.snackbar(
          '해제 완료',
          '북마크에서 제거되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // 변경된 목록 기준으로 위젯 동기화
        final lastBookmark = bookmarks.isEmpty ? null : bookmarks.first;
        WidgetSync.syncLastBookmark(lastBookmark);
      },
    );
  }
}
