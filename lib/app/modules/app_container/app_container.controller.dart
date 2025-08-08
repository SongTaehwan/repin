// 📦 Package imports:
import 'package:get/get.dart';

// 🌎 Project imports:
import 'package:repin/app/routes/app_pages.dart';

class AppContainerController extends GetxController {
  // 선택된 하단 탭 인덱스 상태
  final RxInt selectedIndex = 0.obs;

  // 하단 탭에 대응되는 자식 라우트 경로 (중첩 네비게이터 id: 1 하위)
  final List<String> tabs = [
    Routes.REPOSITORY_SEARCH,
    Routes.REPOSITORY_BOOKMARK,
  ];

  // 하단 탭 변경 처리
  void changeTapItem(int index) {
    // 인덱스 유효성 검사
    if (index < 0 || index >= tabs.length) {
      // 잘못된 인덱스 선택 시 사용자 안내
      Get.snackbar('오류', '잘못된 탭 선택입니다.');
      return;
    }

    // 동일 탭 재선택 시 불필요한 네비게이션 방지
    if (index == selectedIndex.value) {
      return;
    }

    // 상태 업데이트
    selectedIndex.value = index;

    // 중첩 네비게이터(id: 1)에서 자식 라우트 전환 (스택 누적 방지)
    Get.offNamed(tabs[index], id: 1);
  }
}
