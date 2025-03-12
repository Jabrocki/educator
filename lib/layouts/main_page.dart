//Material
import 'package:educator/layouts/decks_page.dart';
import 'package:educator/layouts/login_page.dart';
import 'package:educator/layouts/navigation_obeservers/subject_navigator_observer.dart';
import 'package:flutter/material.dart';

//Layouts
import '../layouts/home_page.dart';
import '../layouts/subject_page.dart';
import '../layouts/menu_subject_page.dart';

//External packges
//import 'package:provider/provider.dart';

//State
//import '../state/main_state.dart';

//Global variables
import '../global_variables.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Which rail destination is selected
  int _selectedIndex = 0;

  // Whether the user is hovering over the rail (to show the extended rail)
  bool _isHovered = false;

  // This flag will determine if a back arrow should be shown for Subjects
  bool _showSubjectsBackButton = false;

  Widget? _subjectFab;
  Widget? _homeFab;
  Widget? _searchFab;

  @override
  Widget build(BuildContext context) {
    // For AppBar leading: only show on Subjects tab when needed.
    Widget? buildNestedNavigatorBackButton() {
      if (_selectedIndex == 1 && _showSubjectsBackButton) {
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            subjectsNavigatorKey.currentState?.pop();
          },
        );
      }
      return null;
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: SizedBox(
            width: 56,
            child: buildNestedNavigatorBackButton() ?? Container(),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school),
              SizedBox(width: 8.0),
              Text(
                "Educator",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          elevation: 2,
          actions: [
            IconButton(onPressed: _logOut, icon: const Icon(Icons.logout))
          ],
        ),
        body: _buildBody(context),
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: _buildFab(),
        ));
  }

  Widget? _buildFab() {
    switch(_selectedIndex) {
      case 0:
          return _homeFab;
      case 1:
          return _subjectFab;
      case 2:
          return _searchFab;
      default:
          return null;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        //Navigation Rail
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: SafeArea(
              child: Material(
            elevation: 4.0,
            child: NavigationRail(
              extended: _isHovered,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text("Home")),
                NavigationRailDestination(
                    icon: Icon(Icons.book), label: Text("Subjects")),
                NavigationRailDestination(
                    icon: Icon(Icons.language), label: Text("Search")),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text("Settings"))
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (value) {
                //Change Navigation Page
                setState(() {
                  _selectedIndex = value;
                });
              },
            ),
          )),
        ),
        Expanded(
            child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Home Tab Navigator
            Navigator(
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
            ),
            // Subjects Tab Navigator
            Navigator(
              key: subjectsNavigatorKey,
              initialRoute: '/subjects',
              observers: [
                SubjectNavigatorObserver(backButtonValChanged: (bool canPop) {
                  setState(() {
                    _showSubjectsBackButton = canPop;
                  });
                }, addButtonValChanged: (Widget? addButton) {
                  setState(() {
                    _subjectFab = addButton;
                  });
                })
              ],
              onGenerateRoute: (RouteSettings settings) {
                late Widget page;
                switch (settings.name) {
                  case '/subjects':
                    page = const SubjectPage();
                    break;
                  case '/subjects/menu':
                    page = const MenuSubjectPage();
                    break;
                  case '/subjects/menu/decks':
                    page = const DecksPage();
                    break;
                  default:
                    page = const SubjectPage();
                }
                return MaterialPageRoute(
                  builder: (_) => page,
                  settings: settings,
                );
              },
            ),
            //Search tab
            //TODO:
            const Text("Search"),
            //TODO:
            const Text("Settings")
          ],
        ))
      ],
    );
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Gives the dialog rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Row(
            children: [
              // A logout/warning icon
              Icon(Icons.warning_amber_rounded, size: 28),
              SizedBox(width: 8.0),
              // Styled text
              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Perform the actual logout logic here
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
