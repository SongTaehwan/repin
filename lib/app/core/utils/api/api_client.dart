// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/api/api_client.interface.dart';
import 'package:repin/app/core/utils/extensions/cache_options..dart';

class ApiClient implements IApiClient {
  // 최대 재시도 횟수
  static const MAX_RETRY = 4;

  // 재시도 딜레이 오프셋 (초)
  static const DELAY_OFFSET = 2;

  late Dio client;

  late CacheStore cacheStore;
  late CacheOptions cacheOptions;

  @override
  Future<void> initialize() async {
    client = Dio();
    client.options.connectTimeout = const Duration(seconds: 120);
    client.options.sendTimeout = const Duration(seconds: 30);
    client.options.receiveTimeout = const Duration(seconds: 30);

    await _onInitCacheStore();
    _onInitRetryInterceptor();
  }

  Future<void> _onInitCacheStore() async {
    final directory = await getTemporaryDirectory();
    cacheStore = HiveCacheStore(directory.path);

    // 캐시 옵션 생성
    cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refreshForceCache,
      maxStale: const Duration(seconds: 1),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    client.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          final key = CacheOptionsExt.customCacheKeyBuilder(options);

          // 캐시 스토어에서 이전 요청 응답 데이터를 불러 옵니다.
          final cache = await cacheStore.get(key);
          // 캐시가 null이 아니고 만료시간이 2초 이내라면 캐시를 사용합니다.
          if (cache != null &&
              DateTime.now().difference(cache.responseDate).inSeconds < 1) {
            return handler.resolve(
              cache.toResponse(options, fromNetwork: false),
            );
          }

          return handler.next(options);
        },
      ),
    );
  }

  _onInitRetryInterceptor() {
    client.interceptors.addAll([
      _createRetryInterceptor(),
      // 디버그 하는경우 로깅처리
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  // 재시도 인터셉터 생성
  InterceptorsWrapper _createRetryInterceptor() {
    onRequest(RequestOptions request, RequestInterceptorHandler handler) async {
      request.headers['Accept'] = 'application/json';
      request.headers['Connection'] = 'Keep-Alive';
      request.headers['Keep-Alive'] = 'timeout=5, max=1000';
      request.headers['X-Request-Retry'] =
          request.headers['X-Request-Retry'] ?? 0;

      return handler.next(request);
    }

    onError(DioException error, ErrorInterceptorHandler handler) async {
      try {
        final int retryCount = error.requestOptions.headers['X-Request-Retry'];

        // 최대 재시도 횟수 초과 시 에러 반환
        if (retryCount >= MAX_RETRY) {
          return handler.next(error);
        }

        // 네트워크 에러 시 재요청
        if (_isNetworkError(error)) {
          final updatedCount = _setRetryCount(error);
          // 재요청 카운트와 딜레이 시간을 비례하도록 설정
          // 예) 1회 2초, 2회 4초, 3회 6초...
          await Future.delayed(Duration(seconds: updatedCount * DELAY_OFFSET));
          final response = await client.fetch(error.requestOptions);
          return handler.resolve(response);
        }

        return handler.next(error);
      } on DioException catch (error) {
        return handler.reject(error);
      }
    }

    return InterceptorsWrapper(onRequest: onRequest, onError: onError);
  }

  // 네트워크 에러 타입 체크
  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout;
  }

  // 요청 재시도 횟수 증가
  int _setRetryCount(DioException error) {
    // 재시도 횟수가 없으면 최대 재시도 횟수를 설정해 추가적인 재시도 방지
    final int retryCount =
        error.requestOptions.headers['X-Request-Retry'] ?? MAX_RETRY;
    final updatedCount = retryCount + 1;
    error.requestOptions.headers['X-Request-Retry'] = updatedCount;
    return updatedCount;
  }

  // 인스턴스 생성
  @factoryMethod
  static Future<ApiClient> create() async {
    final service = ApiClient();
    await service.initialize();
    return service;
  }
}
