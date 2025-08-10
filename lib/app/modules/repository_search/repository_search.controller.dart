// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/constant/strings.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

class RepositorySearchController extends GetxController {
  /// 의존성
  final RepositoryServiceInterface _service;

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

  /// 검색 대기(pending) 상태 여부
  bool get isSearchPending => isDebouncing.value && !isLoading.value;

  /// 생성자
  RepositorySearchController(this._service);

  /// Getter
  TextEditingController get searchController => _searchController;

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

  /// 저장소 검색
  /// GitHub Repository 의 이름은 1글자 이상이므로 빈 문자열 검색은 허용하지 않는다.
  void _searchRepositories(String query) async {
    // 디바운스가 종료되어 실제 검색을 시작하므로 대기 상태 해제
    isDebouncing.value = false;
    _lastLoadNextAt = null; // 새로운 검색 시작 시 스로틀 상태 초기화

    if (query.trim().isEmpty) {
      repositories.clear();
      hasSearched.value = false;
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;

    final result = await _service.loadFirst(query);

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
        final (repositories, totalCount) = repositoriesList;
        this.repositories.value = repositories;
        hasMore.value = _service.hasMore;

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
    if (query.isEmpty || isLoadingMore.value || !hasMore.value) return;

    // 스로틀: 마지막 호출로부터 최소 간격이 지나지 않았다면 무시
    if (!_canLoadNextNow()) {
      return;
    }

    _lastLoadNextAt = DateTime.now();

    isLoadingMore.value = true;
    final result = await _service.loadNext(query);
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
        hasMore.value = _service.hasMore;
      },
    );
    isLoadingMore.value = false;
  }

  /// 다음 페이지 로드 가능 여부 판단 (스로틀 전용)
  bool _canLoadNextNow() {
    if (_lastLoadNextAt == null) {
      return true;
    }

    final elapsed = DateTime.now().difference(_lastLoadNextAt!).inMilliseconds;
    return elapsed >= LOAD_NEXT_THROTTLE_MS;
  }

  /// 검색 실행 (검색바에서 엔터 누를 때)
  void onSearchSubmitted(String query) {
    _searchRepositories(query);
  }
}
