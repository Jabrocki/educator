//Material
import 'package:flutter/material.dart';

//Layouts
import '../search_layouts/search_page.dart';

final GlobalKey<NavigatorState> searchNavigatorKey =
    GlobalKey<NavigatorState>();

class SearchNavigator extends StatelessWidget {
  //Value changed callbacks
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  const SearchNavigator(
      {super.key,
      required this.backButtonValChanged,
      required this.addButtonValChanged});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: searchNavigatorKey,
      initialRoute: '/search',
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;
        switch (settings.name) {
          case '/search':
            page = const SearchPage();
            break;
          default:
            page = const SearchPage();
        }
        return MaterialPageRoute(
          builder: (_) => page, 
          settings: settings
        );
      },
    );
  }
}
