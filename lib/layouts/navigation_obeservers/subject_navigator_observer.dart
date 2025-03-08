//Material

import 'package:flutter/material.dart';

class SubjectNavigatorObserver extends NavigatorObserver {
  final ValueChanged<bool> onNavigationChanged;

  SubjectNavigatorObserver({required this.onNavigationChanged});

  void _notifyRoute(Route? route) {
    final routeName = route?.settings.name;
    // Only show the back arrow if we are NOT on the root '/subjects'
    bool shouldShow = routeName != null && routeName != '/subjects';
    // Defer the callback until after the frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onNavigationChanged(shouldShow);
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _notifyRoute(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _notifyRoute(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notifyRoute(newRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _notifyRoute(previousRoute);
  }
}
