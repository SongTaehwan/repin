// 📦 Package imports:
import 'package:intl/intl.dart';

enum NumberFormatKind { compact, compactLong, decimal }

// kind + locale 조합 키 캐시
final Map<String, NumberFormat> _numberFormatCache = {};

String _key(NumberFormatKind kind, String? locale) =>
    '${kind.name}::${locale ?? Intl.getCurrentLocale()}';

// kind + locale에 맞는 반환 (없으면 생성 후 캐시)
NumberFormat _resolveFormatter(NumberFormatKind kind, {String? locale}) {
  final key = _key(kind, locale);
  final cached = _numberFormatCache[key];

  if (cached != null) {
    return cached;
  }

  late final NumberFormat formatter;

  switch (kind) {
    case NumberFormatKind.compact:
      // 1,234 -> 1.2k
      formatter = NumberFormat.compact(locale: locale);
      break;
    case NumberFormatKind.compactLong:
      // 1,200,000 -> 1.2 million
      formatter = NumberFormat.compactLong(locale: locale);
      break;
    case NumberFormatKind.decimal:
      formatter = NumberFormat.decimalPattern(locale);
      break;
  }

  _numberFormatCache[key] = formatter;
  return formatter;
}

String formatCompact(num value, {String? locale}) =>
    _resolveFormatter(NumberFormatKind.compact, locale: locale).format(value);

String formatCompactLong(num value, {String? locale}) => _resolveFormatter(
  NumberFormatKind.compactLong,
  locale: locale,
).format(value);

String formatDecimal(num value, {String? locale}) =>
    _resolveFormatter(NumberFormatKind.decimal, locale: locale).format(value);
