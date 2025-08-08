// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/modules/repository_search/repository_search.controller.dart';

class RepositorySearchView extends GetView<RepositorySearchController> {
  const RepositorySearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'RepositorySearchView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
