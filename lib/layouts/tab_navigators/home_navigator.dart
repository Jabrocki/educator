import 'package:educator/layouts/home_layouts/home_page.dart';
import 'package:flutter/material.dart';




class HomeNavigator extends StatelessWidget { 

  //Value changed callbacks
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;
  final GlobalKey<NavigatorState> homeNavigatorKey;

  const HomeNavigator({
    super.key,
    required this.backButtonValChanged,
    required this.addButtonValChanged,
    required this.homeNavigatorKey,
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
