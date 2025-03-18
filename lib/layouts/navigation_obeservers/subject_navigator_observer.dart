//Material
import 'package:educator/widgets/custom_pop_up_deck.dart';
import 'package:flutter/material.dart';

//PopUP windows
import '../../widgets/custom_pop_up_subject.dart';


class SubjectNavigatorObserver extends NavigatorObserver {
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  SubjectNavigatorObserver(
      {
        required this.backButtonValChanged, 
        required this.addButtonValChanged,
        });

  void _notifyRoute(Route? route) {
    final routeName = route?.settings.name;

    //If they want to show bak button
    bool shouldShowBackButton = routeName != null && routeName != '/subjects';
    
    Widget? addButton;
    //FAB
    if (routeName != null) {
      switch (routeName) {
        case '/subjects':
          addButton = const AddSubjectButton();
          break;
        case '/subjects/menu':
          addButton = null;
          break;
        case '/subjects/menu/decks':
          addButton = const AddDeckButton();
          break;
        default:
          addButton = null;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backButtonValChanged(shouldShowBackButton);
      addButtonValChanged(addButton);
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

class AddDeckButton extends StatelessWidget {
  const AddDeckButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(context: context, 
        builder: (context) {
          return const CustomPopUpDeck();
        });
      },
      child: const Icon(Icons.add),
    );
  }
}

class AddSubjectButton extends StatelessWidget {
  const AddSubjectButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return const CustomPopUpSubject();
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
