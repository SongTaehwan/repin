// 🐦 Flutter imports:
import 'package:flutter/material.dart';

/// 라우트 스택 상태를 추적하는 옵저버 (루트/중첩 네비게이터 공용)
class RouteStackObserver extends NavigatorObserver {
  // 식별용 이름 (예: 'root', 'child_1')
  final String name;

  // 각 네비게이터별 스택 레지스트리
  static final Map<String, List<Route<dynamic>>> _stacks = {};

  // const 생성자: 동일 name이면 같은 레지스트리에 기록됨
  RouteStackObserver._(this.name);

  // 루트 네비게이터용
  RouteStackObserver.root() : this._('root');

  // 중첩 네비게이터용 (id와 매핑)
  RouteStackObserver.child(int id) : this._('child_$id');

  // 현재 스택 얻기
  List<Route<dynamic>> get _stack =>
      _stacks.putIfAbsent(name, () => <Route<dynamic>>[]);

  // 디버그 로그 출력
  void _logStack() {
    final names = _stack.map((r) => r.settings.name ?? r.toString()).toList();
    debugPrint('[$name] stack: $names');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    _logStack();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _logStack();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _logStack();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _stack.remove(oldRoute);
    if (newRoute != null) _stack.add(newRoute);
    _logStack();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  /// 어디서든 호출 가능한 스택 덤프
  static void dump([String name = 'root']) {
    final stack = _stacks[name] ?? const <Route<dynamic>>[];
    final names = stack.map((r) => r.settings.name ?? r.toString()).toList();
    debugPrint('[$name] stack: $names');
  }
}
