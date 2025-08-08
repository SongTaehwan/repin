// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:uuid/uuid.dart';

extension CacheOptionsExt on CacheOptions {
  static const _uuid = Uuid();

  static String customCacheKeyBuilder(RequestOptions request) {
    return _uuid.v5(
      Uuid.NAMESPACE_URL,
      request.uri.toString() + request.headers.toString(),
    );
  }
}
