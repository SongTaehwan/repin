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

// TODO: 캐싱 구현
// TODO: 커서 기반 페이지네이션 구현 - 마지막 커서 처리
@LazySingleton(as: CodeRepoRepositoryInterface)
class CodeRepoRepository implements CodeRepoRepositoryInterface {
  final GithubProviderInterface _api;
  final int pageSize;

  String? _cursor; // 마지막 페이지 끝 커서
  bool _hasMore = true;

  CodeRepoRepository(this._api, {this.pageSize = 10});

  bool get hasMore => _hasMore;

  @override
  void reset() {
    _cursor = null;
    _hasMore = true;
  }

  void _updateCursor(String? link) {
    final next = extractNextUrlFromLink(link);
    print('next: $next');
    _cursor = next;
    _hasMore = next != null;
  }

  // TODO: Local or remote data source
  @override
  Future<Either<Failure, Future<(List<Repository>, int)>>> fetchFirstPage(
    String query,
  ) async {
    return Either.tryCatch(() async {
      final result = await _api.searchRepositories(query, perPage: pageSize);
      final repositories = result.data.items.map(Repository.fromDto).toList();
      _updateCursor(result.response.headers.map['link']?.first);

      return (repositories, result.data.totalCount);
    }, (error, stackTrace) => Failure.unexpected(error.toString()));
  }

  @override
  Future<Either<Failure, Future<(List<Repository>, int)>>> fetchNextPage(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    // 첫 페이지 요청 시 커서 없음
    if (_cursor == null) {
      return fetchFirstPage(query);
    }

    return Either.tryCatch(() async {
      final result = await _api.searchRepositories(
        query,
        page: page,
        perPage: pageSize,
      );

      final link = result.response.headers.map['link']?.first;
      _updateCursor(link);

      final repositories = result.data.items.map(Repository.fromDto).toList();
      return (repositories, result.data.totalCount);
    }, (error, stackTrace) => Failure.unexpected(error.toString()));
  }
}

// TODO: 마지막 페이지 끝 커서 추출
/// Link 헤더 예시:
/// <...&page=2>; rel="next", <...&page=10>; rel="last"
String? extractNextUrlFromLink(String? linkHeader) {
  if (linkHeader == null) {
    return null;
  }

  for (final part in linkHeader.split(',')) {
    final p = part.trim();
    if (p.contains('rel="next"')) {
      final start = p.indexOf('<');
      final end = p.indexOf('>');
      if (start != -1 && end != -1 && end > start) {
        return p.substring(start + 1, end);
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
