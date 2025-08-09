// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/data/provider/dto/repository.dto.dart';
import 'package:repin/app/data/services/repository_search.service.interface.dart';

class RepositorySearchController extends GetxController {
  final RepositoryServiceInterface _repositoryService;
  final TextEditingController _searchController = TextEditingController();

  // 반응형 상태 변수들
  final RxList<Repository> repositories = <Repository>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;
  final RxString searchText = ''.obs;

  RepositorySearchController(this._repositoryService);

  TextEditingController get searchController => _searchController;

  @override
  void onInit() {
    super.onInit();
    // TextEditingController의 text 변화를 감지
    _searchController.addListener(() {
      searchText.value = _searchController.text;
    });
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
  }

  /// 저장소 검색
  void searchRepositories(String query) async {
    if (query.trim().isEmpty) {
      repositories.clear();
      hasSearched.value = false;
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;

    final result = await _repositoryService.searchRepositories(query);

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
        repositories.value = repositoriesList;
        if (repositoriesList.isEmpty) {
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
    searchRepositories(query);
  }
}
