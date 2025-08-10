// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/extensions/int.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

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
              return _buildRepositoryItem(repository);
            },
          ),
        ),
      );
    });
  }

  /// 저장소 아이템 위젯
  Widget _buildRepositoryItem(Repository repository) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 저장소 이름
          Row(
            children: [
              Expanded(
                child: Text(
                  repository.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // 스타 수
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber[600]),
                  const SizedBox(width: 4),
                  Text(
                    repository.stargazersCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (repository.ownerProfileUrl != null)
                // add border radius
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    repository.ownerProfileUrl!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                repository.ownerName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 설명
          if (repository.description.isNotEmpty)
            Text(
              repository.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          // 메타 정보
          Row(
            children: [
              // 언어
              if (repository.language != null &&
                  repository.language!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    repository.language!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // 포크 수
              Row(
                children: [
                  Icon(Icons.call_split, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.forksCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.remove_red_eye, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.watchersCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.bug_report, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.openIssuesCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
