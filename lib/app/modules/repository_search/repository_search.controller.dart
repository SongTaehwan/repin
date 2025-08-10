// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

class RepositorySearchController extends GetxController {
  // 의존성
  final RepositoryServiceInterface _repositoryService;

  // 인스턴스
  final TextEditingController _searchController = TextEditingController();

  // 반응형 상태 변수들
  final RxList<Repository> repositories = <Repository>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;
  final RxString searchText = ''.obs;
  final RxBool isDebouncing = false.obs; // 디바운스 대기 상태 표시

  /// '검색 중...' 인디케이터 표시 여부를 캡슐화
  bool get showDebounceIndicator => isDebouncing.value && !isLoading.value;

  // 생성자
  RepositorySearchController(this._repositoryService);

  //Getter
  TextEditingController get searchController => _searchController;

  @override
  void onInit() {
    super.onInit();
    _setupSearchTextListener();
    _setupDebounce();
  }

  void _setupSearchTextListener() {
    _searchController.addListener(() {
      // 입력값 변경 시 상태 동기화 및 디바운스 대기 상태 갱신
      final current = _searchController.text;
      searchText.value = current;
      isDebouncing.value = current.trim().isNotEmpty;
    });
  }

  /// 검색어 변경 시 300ms 디바운스를 적용하여 불필요한 API 호출을 방지
  // NOTE: GetX의 debounce는 컨트롤러 dispose 시 자동 정리됨
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
  }

  /// 저장소 검색
  /// GitHub Repository 의 이름은 1글자 이상이므로 빈 문자열 검색은 허용하지 않는다.
  void _searchRepositories(String query) async {
    // 디바운스가 종료되어 실제 검색을 시작하므로 대기 상태 해제
    isDebouncing.value = false;

    if (query.trim().isEmpty) {
      repositories.clear();
      hasSearched.value = false;
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
      (repositoriesList) async {
        final (repositories, totalCount) = await repositoriesList;
        this.repositories.value = repositories;

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

  /// 검색 실행 (검색바에서 엔터 누를 때)
  void onSearchSubmitted(String query) {
    _searchRepositories(query);
  }
}
