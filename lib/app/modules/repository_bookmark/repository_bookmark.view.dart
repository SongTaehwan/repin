// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_bookmark/repository_bookmark.controller.dart';

class RepositoryBookmarkView extends GetView<RepositoryBookmarkController> {
  const RepositoryBookmarkView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'RepositoryBookmarkView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
