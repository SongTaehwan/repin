// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';

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
      },
    );
  }
}
