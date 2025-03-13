//Libary name
library main_database;

//Models
import '../models/deck_model.dart';
import '../models/image_model.dart';
import '../models/subject_model.dart';

//External packges
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Internal packages
import 'dart:io';

//Database config
import 'database_config.dart';

//Parts
part 'users_database.dart';
part "subjects_database.dart";
part "images_database.dart";
part "decks_database.dart";

class DatabaseService {
  //Singleton
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  //Database instance
  static Database? _db;

  //Getter for database
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //Init Sql Commands

  //Drops all tables in the database
  Future<void> clearDatabase(Database database) async {
    await database.execute("DROP TABLE IF EXISTS $subjectsTableName");
    await database.execute("DROP TABLE IF EXISTS $imagesTableName");
    await database.execute("DROP TABLE IF EXISTS $usersTableName");
    await database.execute("DROP TABLE IF EXISTS $decksTableName");
    await database.execute("DROP TABLE IF EXISTS $flashcardTableName");
  }

  //Init database
  Future<Database> initDb() async {
    //Database path
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, databaseName);

    final database = await openDatabase(
      databasePath,
      version: 6,
      onCreate: (db, version) {
        db.execute(initSubjects);
        db.execute(initImages);
        db.execute(initUsers);
        db.execute(initDecks);
        db.execute(initFlashcards);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await clearDatabase(db);
        await db.execute(initSubjects);
        await db.execute(initImages);
        await db.execute(initUsers);
        await db.execute(initDecks);
        await db.execute(initFlashcards);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("rememberUser", false);
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        await clearDatabase(db);
        await db.execute(initSubjects);
        await db.execute(initImages);
        await db.execute(initUsers);
        await db.execute(initDecks);
        await db.execute(initFlashcards);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("rememberUser", false);
      },
    );

    return database;
  }
}
