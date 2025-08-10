// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';
import 'package:repin/app/shared/widgets/repository_list_item.dart';

/// 저장소 검색 화면
class RepositorySearchView extends GetView<RepositorySearchController> {
  const RepositorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 검색바
            _buildSearchBar(),
            // 디바운스 대기 표시 텍스트
            _buildDebounceIndicator(),
            // 리스트 영역
            Expanded(child: _buildRepositoryList()),
          ],
        ),
      ),
    );
  }

  /// 검색바 위젯
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 돋보기 아이콘
          Icon(Icons.search, color: Colors.grey[600], size: 24),
          const SizedBox(width: 12),
          // 검색 입력 필드
          Expanded(
            child: TextField(
              controller: controller.searchController,
              onSubmitted: controller.onSearchSubmitted,
              decoration: InputDecoration(
                hintText: '검색할 저장소 이름을 입력하세요',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          // X 버튼
          Obx(() {
            if (controller.searchText.isEmpty) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: controller.clearSearch,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.grey[600], size: 18),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 디바운스 대기 상태를 표시하는 텍스트 위젯
  Widget _buildDebounceIndicator() {
    return Obx(() {
      if (!controller.isSearchPending) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '검색 중...',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      );
    });
  }

  /// 저장소 리스트 위젯
  Widget _buildRepositoryList() {
    return Obx(() {
      // 로딩 중
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // 검색하지 않은 상태
      if (!controller.hasSearched.value) {
        return _buildFallbackMessage('검색어를 입력해주세요');
      }

      // 검색 결과가 없는 경우
      if (controller.repositories.isEmpty) {
        return _buildFallbackMessage('검색 결과가 없습니다');
      }

      // 검색 결과 리스트
      return RefreshIndicator(
        onRefresh: controller.refreshPage,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            controller.onScrollPosition(
              pixels: notification.metrics.pixels,
              maxScrollExtent: notification.metrics.maxScrollExtent,
            );
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.repositories.length + 1,
            itemBuilder: (context, index) {
              // 하단 로딩 인디케이터 또는 빈 공간
              if (index == controller.repositories.length) {
                return Obx(() {
                  if (!controller.isLoadingMore.value) {
                    return const SizedBox(height: 16);
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                });
              }

              final repository = controller.repositories[index];
              return RepositoryListItem(
                repository: repository,
                trailingActions: [
                  GetBuilder<RepositorySearchController>(
                    id: 'bookmark_${repository.id}',
                    builder: (_) {
                      return FutureBuilder<bool>(
                        future: controller.isBookmarked(repository.id),
                        builder: (context, snapshot) {
                          final isBookmarked = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked
                                  ? Colors.blueAccent
                                  : Colors.grey[500],
                            ),
                            onPressed: () async {
                              await controller.toggleBookmark(repository);
                              controller.update(['bookmark_${repository.id}']);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  /// Fallback 메시지 위젯
  Widget _buildFallbackMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
