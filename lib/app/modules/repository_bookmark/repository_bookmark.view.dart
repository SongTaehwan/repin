// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_bookmark/repository_bookmark.controller.dart';
import 'package:repin/app/shared/widgets/repository_list_item.dart';

class RepositoryBookmarkView extends GetView<RepositoryBookmarkController> {
  const RepositoryBookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBookmarkList(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('북마크'),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Obx(() {
              return Text(
                '총 ${controller.bookmarks.length}개',
                style: const TextStyle(fontSize: 14),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkList() {
    return Obx(() {
      if (controller.bookmarks.isEmpty) {
        return const Center(child: Text('저장된 즐겨찾기가 없습니다.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.bookmarks.length,
        itemBuilder: (context, index) {
          final repository = controller.bookmarks[index];
          return RepositoryListItem(
            repository: repository,
            trailingActions: [
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.blueAccent),
                onPressed: () => controller.unbookmark(repository),
              ),
            ],
          );
        },
      );
    });
  }
}
