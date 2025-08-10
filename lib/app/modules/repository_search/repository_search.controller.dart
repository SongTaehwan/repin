// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/constant/strings.dart';
import 'package:repin/app/core/utils/helpers/widget_sync.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/services/repository_bookmark.service.interface.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

/// 저장소 검색 화면 컨트롤러
class RepositorySearchController extends GetxController {
  /// 의존성
  final RepositoryServiceInterface _repositoryService;
  final RepositoryBookmarkServiceInterface _bookmarkService;

  /// 인스턴스
  final TextEditingController _searchController = TextEditingController();

  /// 반응형 상태 변수들
  final RxList<Repository> repositories = <Repository>[].obs; // 검색 결과 리스트
  final RxBool isLoading = false.obs; // 로딩 상태 표시
  final RxBool hasSearched = false.obs; // 검색 결과 존재 여부
  final RxString searchText = ''.obs; // 검색어
  final RxBool isDebouncing = false.obs; // 디바운스 대기 상태 표시
  final RxBool isLoadingMore = false.obs; // 추가 페이지 로딩 상태
  final RxBool hasMore = true.obs; // 추가 페이지 존재 여부

  /// 스로틀 설정
  DateTime? _lastLoadNextAt; // 마지막 다음 페이지 로드 시각

  /// 생성자
  RepositorySearchController(this._repositoryService, this._bookmarkService);

  /// Getter
  TextEditingController get searchController => _searchController;

  /// 검색 대기(pending) 상태 여부
  bool get isSearchPending => isDebouncing.value && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _setupSearchTextListener();
    _setupDebounce();
  }

  /// 입력값 변경 시 상태 동기화 및 디바운스 대기 상태 갱신
  void _setupSearchTextListener() {
    _searchController.addListener(() {
      final current = _searchController.text;
      searchText.value = current;
      isDebouncing.value = current.trim().isNotEmpty;
    });
  }

  /// 검색어 변경 시 300ms 디바운스를 적용하여 불필요한 API 호출을 방지
  /// NOTE: GetX의 debounce는 컨트롤러 dispose 시 자동 정리됨
  void _setupDebounce() {
    debounce<String>(
      searchText,
      (text) => _searchRepositories(text),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _searchController.dispose();
    super.onClose();
  }

  /// 검색어 지우기
  void clearSearch() {
    _searchController.clear();
    repositories.clear();
    hasSearched.value = false;
    isDebouncing.value = false;
    isLoadingMore.value = false;
    hasMore.value = true;
    _lastLoadNextAt = null; // 스로틀 상태 초기화
  }

  /// 북마크 여부 조회
  Future<bool> isBookmarked(int repositoryId) async {
    return _bookmarkService.isBookmarked(repositoryId);
  }

  /// 북마크 토글
  Future<void> toggleBookmark(Repository repository) async {
    final bookmarked = await _bookmarkService.isBookmarked(repository.id);
    if (bookmarked) {
      final result = await _bookmarkService.removeBookmark(repository.id);
      result.fold(
        (failure) => Get.snackbar(
          '북마크 해제 실패',
          failure.toString(),
          snackPosition: SnackPosition.BOTTOM,
        ),
        (_) => Get.snackbar(
          '북마크 해제',
          '해당 저장소가 북마크에서 제거되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
      // 위젯 동기화
      final last = await _bookmarkService.getLastAddedBookmark();
      await WidgetSync.syncLastBookmark(last);
    } else {
      final result = await _bookmarkService.addBookmark(repository);
      result.fold(
        (failure) => Get.snackbar(
          '북마크 실패',
          failure.toString(),
          snackPosition: SnackPosition.BOTTOM,
        ),
        (_) => Get.snackbar(
          '북마크 완료',
          '해당 저장소가 북마크에 추가되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
      // 위젯 동기화
      await WidgetSync.syncLastBookmark(repository);
    }
    update();
  }

  /// 저장소 검색
  /// GitHub Repository 의 이름은 1글자 이상이므로 빈 문자열 검색은 허용하지 않는다.
  void _searchRepositories(String query) async {
    // 디바운스가 종료되어 실제 검색을 시작하므로 대기 상태 해제
    isDebouncing.value = false;
    _lastLoadNextAt = null; // 새로운 검색 시작 시 스로틀 상태 초기화

    if (query.trim().isEmpty) {
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;

    final result = await _repositoryService.loadFirst(query);

    result.fold(
      (failure) {
        Get.snackbar(
          '검색 실패',
          failure.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
        repositories.clear();
      },
      (repositoriesList) {
        final (repositories, _) = repositoriesList;
        this.repositories.value = repositories;
        hasMore.value = _repositoryService.hasMore;

        if (repositories.isEmpty) {
          Get.snackbar(
            '검색 결과',
            '검색 결과가 없습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );

    isLoading.value = false;
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadNextPage() async {
    // 입력된 검색어가 없거나, 이미 로딩 중이거나, 더 이상 데이터가 없다면 종료
    final query = searchText.value.trim();
    if (query.isEmpty || isLoadingMore.value || !hasMore.value) {
      return;
    }

    // 스로틀: 마지막 호출로부터 최소 시간이 지나지 않았다면 무시
    if (!_canLoadNextNow()) {
      return;
    }

    _lastLoadNextAt = DateTime.now();
    isLoadingMore.value = true;

    final result = await _repositoryService.loadNext(query);

    result.fold(
      (failure) {
        Get.snackbar(
          '불러오기 실패',
          failure.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (repositoriesList) {
        final (nextItems, _) = repositoriesList;
        repositories.addAll(nextItems);
        hasMore.value = _repositoryService.hasMore;
      },
    );
    isLoadingMore.value = false;
  }

  /// 스크롤 위치 입력을 받아 다음 페이지 로드 여부를 판단하고 즉시 로드
  /// - 뷰는 UI 타입을 넘기지 않고 현재 위치 값만 전달한다
  void onScrollPosition({
    required double pixels,
    required double maxScrollExtent,
  }) {
    // 하단 근접 여부 판단
    final nearBottom =
        pixels >= maxScrollExtent - INFINITE_SCROLL_TRIGGER_OFFSET_PX;

    final canLoadNext = nearBottom && !isLoadingMore.value && hasMore.value;

    if (!canLoadNext) {
      return;
    }

    // 조건 충족 시 다음 페이지 로드
    loadNextPage();
  }

  /// 다음 페이지 로드 가능 여부 판단 (스로틀 전용)
  bool _canLoadNextNow() {
    final lastLoadNextAt = _lastLoadNextAt;

    if (lastLoadNextAt == null) {
      return true;
    }

    final elapsed = DateTime.now().difference(lastLoadNextAt).inMilliseconds;
    return elapsed >= LOAD_NEXT_THROTTLE_MS;
  }

  /// 검색 실행 (검색바에서 엔터 누를 때)
  void onSearchSubmitted(String query) {
    _searchRepositories(query);
  }

  /// 당겨서 새로고침 처리
  /// - 현재 검색어 기준으로 첫 페이지를 다시 로드한다.
  Future<void> refreshPage() async {
    final query = searchText.value.trim();

    if (query.isEmpty) {
      return;
    }

    // 추가 로딩 상태 초기화
    isLoadingMore.value = false;
    _lastLoadNextAt = null;

    final result = await _repositoryService.loadFirst(query);

    result.fold(
      (failure) {
        Get.snackbar(
          '새로고침 실패',
          failure.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (repositoriesList) {
        final (items, _) = repositoriesList;
        repositories.value = items;
        hasMore.value = _repositoryService.hasMore;
      },
    );
  }
}
