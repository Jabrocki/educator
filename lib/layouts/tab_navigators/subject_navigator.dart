//Provider
import 'package:educator/layouts/subjects_layouts/flashcard_edit_page.dart';
import 'package:educator/state/deck_list_state.dart';
import 'package:educator/state/subject_list_state.dart';
import 'package:educator/widgets/grid_deck/grid_deck.dart';
import 'package:path/path.dart';

//import '../subjects_layouts/subject_page.dart';
import '../subjects_layouts/animated_menu_page.dart';
import 'package:provider/provider.dart';
import '../../widgets/grid_subject/grid_subject.dart';
import '../../state/main_state.dart';

import '../subjects_layouts/decks_page.dart';

import '../../models/menu_item_model.dart';
import '../../widgets/grid_menu/grid_menu.dart';

//Naviagtor observers
import '../navigation_obeservers/subject_navigator_observer.dart';

//Material
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> subjectsNavigatorKey =
    GlobalKey<NavigatorState>();

class SubjectNavigator extends StatelessWidget {
  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  const SubjectNavigator(
      {super.key,
      required this.backButtonValChanged,
      required this.addButtonValChanged});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: subjectsNavigatorKey,
      initialRoute: '/subjects',
      observers: [
        SubjectNavigatorObserver(
            backButtonValChanged: backButtonValChanged,
            addButtonValChanged: addButtonValChanged)
      ],
      onGenerateRoute: (RouteSettings settings) {
        late Widget page;
        switch (settings.name) {
          case '/subjects':
            page = _subjectsPage();
            break;
          case '/subjects/menu':
            page = _menuPage();
            break;
          case '/subjects/menu/decks':
            page = _decksPage();
            break;
          case '/subjects/menu/decks/edit_flashcards':
            page = const FlashcardEditPage();
            break;
          default:
            page = _subjectsPage();
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }

  Widget _subjectsPage() {
    return Consumer<SubjectListState>(
        builder: (context, subjectListState, ___) {
      final subjects = subjectListState.subjects;
      void onTap(int index) {
        //TODO: Move subject id to subject state
        Provider.of<MainState>(context, listen: false).subjectId =
            subjects[index].subjectId;
        Navigator.of(context).pushNamed('/subjects/menu');
      }

      return AnimatedMenuPage(
          items: subjects,
          stackCard: 1,
          maxCrossAxisExtent: 250,
          title: 'Subjects',
          childBuilder: (index) => GridSubject(subject: subjects[index]),
          onTap: onTap);
    });
  }

  Widget _menuPage() {
    return Builder(builder: (context) {
      final List<MenuItemModel> items = [
        const MenuItemModel(
          label: "FlashCards",
          icon: Icons.web_stories,
          navigation: "/subjects/menu/decks",
        ),
        const MenuItemModel(
            label: "Quizes",
            icon: Icons.quiz,
            navigation: "/subjects/menu/quizes"),
        const MenuItemModel(
            label: "Notes",
            icon: Icons.note,
            navigation: "/subjects/menu/notes"),
        const MenuItemModel(
            label: "Files",
            icon: Icons.file_open,
            navigation: "/subjects/menu/files")
      ];

      return AnimatedMenuPage(
        items: items,
        stackCard: 1,
        maxCrossAxisExtent: 250,
        title: 'Menu',
        childBuilder: (index) => GridMenu(menuItemModel: items[index]),
        onTap: (index) {
          Navigator.of(context).pushNamed(items[index].navigation);
        },
      );
    });
  }

  Widget _decksPage() {
    return Consumer<DeckListState>(
      builder: (context, deckListState, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final mainState = Provider.of<MainState>(context, listen: false);
          await deckListState.decksInit(mainState.subjectId);
        });

        final decks = deckListState.decks;

        return AnimatedMenuPage(
          items: decks, 
          stackCard: 1, 
          maxCrossAxisExtent: 250, 
          title: 'Decks', 
          childBuilder: (index) => GridDeck(deck: decks[index]), 
          onTap: (index) {}
        );
      },
    );
  }
}
