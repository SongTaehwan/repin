// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:home_widget/home_widget.dart';

// 🌎 Project imports:
import 'package:repin/app/data/model/repository.model.dart';

/// iOS/Android 위젯 동기화 유틸
class WidgetSync {
  // App Group ID (iOS), Android는 무시됨
  static const String appGroupId = 'group.song.repin.shared';
  static const String iOSWidgetKind = 'RepinWidget';

  /// 마지막 북마크 1건을 위젯에 반영
  static Future<void> syncLastBookmark(Repository? repo) async {
    await HomeWidget.setAppGroupId(appGroupId);

    if (repo == null) {
      await HomeWidget.saveWidgetData<String>('latest_repo', jsonEncode(null));
    } else {
      await HomeWidget.saveWidgetData<String>(
        'latest_repo',
        jsonEncode(repo.toJson()),
      );
    }

    await HomeWidget.updateWidget(iOSName: iOSWidgetKind);
  }
}
