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
      await HomeWidget.saveWidgetData<String>('emoji', 'No bookmark');
      // await HomeWidget.saveWidgetData<int>('count', 0);
    } else {
      await HomeWidget.saveWidgetData<String>('emoji', repo.name);
      // await HomeWidget.saveWidgetData<int>('count', repo.stargazersCount);
    }

    await HomeWidget.updateWidget(iOSName: iOSWidgetKind);
  }
}
