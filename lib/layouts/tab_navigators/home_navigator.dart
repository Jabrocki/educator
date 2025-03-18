import 'package:educator/layouts/home_layouts/home_page.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();


class HomeNavigator extends StatelessWidget { 

  //Value changed callbacks
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  const HomeNavigator({
    super.key,
    required this.backButtonValChanged,
    required this.addButtonValChanged
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;
        switch (settings.name) {
          case '/home':
            page = const HomePage();
            break;
          default:
            page = const HomePage();
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}
