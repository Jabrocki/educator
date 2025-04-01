//Provider
import 'package:educator/layouts/subjects_layouts/flashcard_edit_page.dart';
import 'package:educator/state/subject_list_state.dart';

//import '../subjects_layouts/subject_page.dart';
import '../subjects_layouts/animated_menu_page.dart';
import 'package:provider/provider.dart';
import '../../widgets/grid_subject/grid_subject.dart';
import '../../state/main_state.dart';

import '../subjects_layouts/decks_page.dart';
import '../subjects_layouts/menu_subject_page.dart';

//Naviagtor observers
import '../navigation_obeservers/subject_navigator_observer.dart';

//Material
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> subjectsNavigatorKey = GlobalKey<NavigatorState>();

class SubjectNavigator extends StatelessWidget {

  final ValueChanged<bool> backButtonValChanged;
  final ValueChanged<Widget?> addButtonValChanged;

  const SubjectNavigator({
    super.key,
    required this.backButtonValChanged,
    required this.addButtonValChanged
  });

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
            page = const MenuSubjectPage();
            break;
          case '/subjects/menu/decks':
            page = const DecksPage();
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

  Widget _subjectsPage(

  ) {
    return Builder(
      builder: (context) {
        return Consumer<SubjectListState>(
          builder: (_,subjectListState,___) {
            final subjects = subjectListState.subjects;
            void onTap(int index) {
              //TODO: Move subject id to subject state
              Provider.of<MainState>(context, listen: false).subjectId = subjects[index].subjectId;
              Navigator.of(context).pushNamed('/subjects/menu');
            }
            
            return AnimatedMenuPage(
                    items: subjects, 
                    stackCard: 1, 
                    maxCrossAxisExtent: 250, 
                    title: 'Subjects', 
                    childBuilder: (index) => GridSubject(subject: subjects[index]), 
                    onTap: onTap
            );
          }
        );
      }
    );
  }
}
