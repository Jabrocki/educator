import 'package:educator/layouts/settings_layouts/settings_page.dart';
import 'package:flutter/material.dart';


final GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey<NavigatorState>();

class SettingsNavigator extends StatelessWidget {
  
  //Value changed callbacks
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  const SettingsNavigator({
    super.key,
    required this.backButtonValChanged,
    required this.addButtonValChanged
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: settingsNavigatorKey,
      initialRoute: '/settings',
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;
        switch (settings.name) {
          case '/settings':
            page = const SettingsPage();
            break;
          default:
            page = const SettingsPage();
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings
        );
      },
    );
  }
}
