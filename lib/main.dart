//Packages
import 'package:educator/state/flashcard_list_state.dart';
import 'package:provider/provider.dart';


//Material
import 'package:flutter/material.dart';

//State
import 'state/main_state.dart';
import 'state/subject_list_state.dart';
import 'state/deck_list_state.dart';
import 'state/animation_state.dart';

//LogInPage
import 'package:educator/layouts/login_layouts/login_page.dart';

//MainPage
import 'layouts/main_page.dart';


//Database
import 'database/database_config.dart';
import 'package:educator/database/main_database.dart';

//Quill
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  //Ensure the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Create and initialize main state
  final mainState = MainState();
  await mainState.init();

  //Config
  await DatabaseConfig.configDb.initConfig();

  //Database
  await DatabaseService.instance.initDb();

  //Create subject state
  final subjectState = SubjectListState();
  subjectState.userId = mainState.userId!;
  await subjectState.subjectInit(subjectState.userId);

  //Init shared preffernces instance
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MainState>.value(value: mainState),
      ChangeNotifierProvider<SubjectListState>.value(value: subjectState),
      ChangeNotifierProvider(create: (_) => DeckListState()),
      ChangeNotifierProvider(create: (_) => AnimationState()),
      ChangeNotifierProvider(create: (_) => FlashcardListState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainState = Provider.of<MainState>(context);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      home: 
    mainState.rememberUser ?
    const MainPage() :
    const LoginPage() ,
    theme: mainTheme
    );
  }
}

//Main theme
final mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
     seedColor: Colors.blue,
     primaryContainer: const Color.fromARGB(255, 219, 238, 255)
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color.fromARGB(255, 227, 246, 255),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 2)
    ),

  )
);
