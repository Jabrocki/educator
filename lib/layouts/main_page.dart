//Provider

import 'package:educator/layouts/tab_navigators/home_navigator.dart';
import 'package:educator/layouts/tab_navigators/search_navigator.dart';
import 'package:educator/layouts/tab_navigators/settings_navigator.dart';
import 'package:educator/layouts/tab_navigators/subject_navigator.dart';
import 'package:educator/state/animation_state.dart';
import 'package:provider/provider.dart';

//Material
import 'package:flutter/material.dart';

//Layouts
import 'login_layouts/login_page.dart';

//State
import '../state/main_state.dart';
import '../state/subject_list_state.dart';
import '../state/layout_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Whether the user is hovering over the rail (to show the extended rail)
  bool _isHovered = false;

  //Flag to check if we want to show back button
  bool _showSubjectsBackButton = false;
  bool _showHomeBackButton = false;
  bool _showSearchBackButton = false;
  bool _showSettingsBackButton = false;

  //Fabs
  Widget? _subjectFab;
  Widget? _homeFab;
  Widget? _searchFab;
  Widget? _settingsFab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: _buildFab(context),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget? nestedBackButton;

    //Animation state
    final animationState = Provider.of<AnimationState>(context);


    //Handling logic for bakc button
    switch (animationState.selectedIndex) {
      case 0:
        if (_showHomeBackButton) {
          nestedBackButton = IconButton(
              onPressed: () {
                homeNavigatorKey.currentState?.pop();
                animationState.reAnimate = true;
              },
              icon: const Icon(Icons.arrow_back));
        }
        break;
      case 1:
        if (_showSubjectsBackButton) {
          nestedBackButton = IconButton(
            onPressed: () {
              subjectsNavigatorKey.currentState?.pop();
              animationState.reAnimate = true;
            },
            icon: const Icon(Icons.arrow_back),
          );
        }
        break;
      case 2:
        if (_showSearchBackButton) {
          nestedBackButton = IconButton(
              onPressed: () {
                searchNavigatorKey.currentState?.pop();
                animationState.reAnimate = true;
              },
              icon: const Icon(Icons.arrow_back));
        }
        break;
      case 3:
        if (_showSettingsBackButton) {
          nestedBackButton = IconButton(
              onPressed: () {
                settingsNavigatorKey.currentState?.pop();
                animationState.reAnimate = true;
              },
              icon: const Icon(Icons.arrow_back));
        }
        break;
      default:
        nestedBackButton = null;
    }
    return AppBar(
      automaticallyImplyLeading: false,
      leading: SizedBox(
        width: 56,
        child: nestedBackButton ?? Container(),
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
      actions: [IconButton(onPressed: _logOut, icon: const Icon(Icons.logout))],
    );
  }

  Widget? _buildFab(BuildContext context) {
    //Animation state
    final animationState = Provider.of<AnimationState>(context);

    switch (animationState.selectedIndex) {
      case 0:
        return _homeFab;
      case 1:
        return _subjectFab;
      case 2:
        return _searchFab;
      default:
        return _settingsFab;
    }
  }

  Widget _buildBody(BuildContext context) {

    final animationState = Provider.of<AnimationState>(context);

    return Stack(
      children: [
        Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              width: _isHovered ? 260 : 85,
            ),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final layoutState =
                    Provider.of<LayoutState>(context, listen: false);
                // Update width
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  layoutState.updateMaxWidth(constraints.maxWidth);
                });
                return IndexedStack(
                  index: animationState.selectedIndex,
                  children: [
                    HomeNavigator(
                      backButtonValChanged: (bool canPop) =>
                          setState(() => _showHomeBackButton = canPop),
                      addButtonValChanged: (Widget? addButton) =>
                          setState(() => _homeFab = addButton),
                    ),
                    SubjectNavigator(
                      backButtonValChanged: (bool canPop) =>
                          setState(() => _showSubjectsBackButton = canPop),
                      addButtonValChanged: (Widget? addButton) =>
                          setState(() => _subjectFab = addButton),
                    ),
                    SearchNavigator(
                      backButtonValChanged: (bool canPop) =>
                          setState(() => _showSearchBackButton = canPop),
                      addButtonValChanged: (Widget? addButton) =>
                          setState(() => _searchFab = addButton),
                    ),
                    SettingsNavigator(
                      backButtonValChanged: (bool canPop) =>
                          setState(() => _showSettingsBackButton = canPop),
                      addButtonValChanged: (Widget? addButton) =>
                          setState(() => _settingsFab = addButton),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: SafeArea(
              child: Material(
                elevation: 8.0,
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
                  selectedIndex: animationState.selectedIndex,
                  onDestinationSelected: (value) => animationState.selectedIndex = value,
                ),
              ),
            ),
          ),
        ),
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
                final mainState =
                    Provider.of<MainState>(context, listen: false);
                mainState.rememberUser = false;
                mainState.userId = 0;
                mainState.userName = '';
                Provider.of<SubjectListState>(context, listen: false).userId =
                    0;

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
