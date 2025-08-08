part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ENTRY = _Paths.ENTRY;
  static const REPOSITORY_SEARCH = _Paths.REPOSITORY_SEARCH;
  static const REPOSITORY_BOOKMARK = _Paths.REPOSITORY_BOOKMARK;
}

abstract class _Paths {
  _Paths._();
  static const ENTRY = '/';
  static const REPOSITORY_SEARCH = '/search';
  static const REPOSITORY_BOOKMARK = '/bookmark';
}
