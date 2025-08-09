// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchView extends GetView<RepositorySearchController> {
  const RepositorySearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 검색바
            _buildSearchBar(),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                hintText: '저장소를 검색하세요...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          // X 버튼
          Obx(() {
            return controller.searchText.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearSearch,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
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
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.repositories.length,
        itemBuilder: (context, index) {
          final repository = controller.repositories[index];
          return _buildRepositoryItem(repository);
        },
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
            color: Colors.black.withOpacity(0.05),
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
                    repository.stargazersCount.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 설명
          if (repository.description != null &&
              repository.description.isNotEmpty)
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
                    repository.forksCount.toString(),
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
