// 🌎 Project imports:
import 'package:repin/app/core/utils/format/number_format.dart' as format;

extension FormattedInt on int {
  // 1,234 -> 1.2k
  String formatCompact(String? locale) {
    return format.formatCompact(this, locale: locale);
  }

  // 1,200,000 -> 1.2 million
  String formatCompactLong(String? locale) {
    return format.formatCompactLong(this, locale: locale);
  }

  String formatDecimal(String? locale) {
    return format.formatDecimal(this, locale: locale);
  }
}
