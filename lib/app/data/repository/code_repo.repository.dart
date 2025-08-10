// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

// 🌎 Project imports:
import 'package:repin/app/core/errors/failure.dart';
import 'package:repin/app/data/model/repository.model.dart';
import 'package:repin/app/data/provider/github.provider.interface.dart';
import 'package:repin/app/data/repository/code_repo.repository.interface.dart';

// 역할 - 데이터 소스 접근 추상화
// 1. 데이터 소스 에러 → 도메인 에러로 맵핑
// 2. DTO → 도메인 모델 매핑
// 3. 캐싱
@LazySingleton(as: CodeRepoRepositoryInterface)
class CodeRepoRepository implements CodeRepoRepositoryInterface {
  final GithubProviderInterface _api;
  final int _pageSize;

  int? _nextPage; // 마지막 페이지 끝 커서

  CodeRepoRepository(this._api, {int pageSize = 10}) : _pageSize = pageSize;

  int? get nextPage => _nextPage;

  @override
  void reset() {
    _nextPage = null;
  }

  // 데이터 조회 및 페이징 처리
  Future<(List<Repository>, int)> _fetchPage(
    String query, {
    int page = 1,
    int? limit,
  }) async {
    final result = await _api.searchRepositories(
      query,
      perPage: limit ?? _pageSize,
      page: page,
    );

    // 페이징 커서 업데이트
    _updateNextPageFromLink(
      readHeaderIgnoreCase(result.response.headers.map, 'link'),
    );

    final repositories = result.data.items.map(Repository.fromDto).toList();
    return (repositories, result.data.totalCount);
  }

  void _updateNextPageFromLink(String? link) {
    final nextPageUrl = extractNextUrlFromLink(link);
    final nextPage = extractNextPageFromUrl(nextPageUrl);

    // 디버그 모드에서만 링크 파싱 로그 출력
    if (kDebugMode) {
      debugPrint('link: $link');
      debugPrint('nextPageUrl: $nextPageUrl');
      debugPrint('next: $nextPage');
    }

    _nextPage = nextPage;
  }

  // TODO: 캐싱 정책에 따라 로컬 또는 리모트 데이터 소스 사용
  @override
  Future<Either<Failure, (List<Repository>, int)>> fetchFirstPage(
    String query,
  ) {
    return TaskEither.tryCatch(
      () => _fetchPage(query, page: 1, limit: _pageSize),
      (error, stackTrace) => Failure.unexpected(error.toString()),
    ).run();
  }

  @override
  Future<Either<Failure, (List<Repository>, int)>> fetchNextPage(String query) {
    // 첫 페이지 요청 시 커서 없음
    if (_nextPage == null) {
      return fetchFirstPage(query);
    }

    final nextPage = _nextPage!;

    return TaskEither.tryCatch(
      () => _fetchPage(query, page: nextPage, limit: _pageSize),
      (error, stackTrace) => Failure.unexpected(error.toString()),
    ).run();
  }
}

/// Link 헤더 예시:
/// <...&page=2>; rel="next", <...&page=10>; rel="last"
String? extractNextUrlFromLink(String? linkHeader) {
  if (linkHeader == null) {
    return null;
  }

  for (final part in linkHeader.split(',')) {
    final trimmedPart = part.trim();

    if (trimmedPart.contains('rel="next"')) {
      final start = trimmedPart.indexOf('<');
      final end = trimmedPart.indexOf('>');

      if (start != -1 && end != -1 && end > start) {
        return trimmedPart.substring(start + 1, end);
      }
    }
  }

  return null;
}

int? extractNextPageFromUrl(String? url) {
  if (url == null) {
    return null;
  }

  final uri = Uri.parse(url);
  final pageStr = uri.queryParameters['page'];
  return pageStr == null ? null : int.tryParse(pageStr);
}

/// 헤더 키를 대소문자 구분 없이 조회하여 첫 번째 값을 반환
String? readHeaderIgnoreCase(Map<String, List<String>> headers, String name) {
  final lower = name.toLowerCase();

  for (final entry in headers.entries) {
    if (entry.key.toLowerCase() == lower && entry.value.isNotEmpty) {
      return entry.value.first;
    }
  }

  return null;
}
