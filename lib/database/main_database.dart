//Libary name
// ignore_for_file: depend_on_referenced_packages

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
part "flashcards_database.dart";

class DatabaseService {
  //Singleton
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  //Database instance
  late Database db;

  //Config
  DatabaseConfig configDb = DatabaseConfig.configDb;

  //Drops all tables in the database
  Future<void> clearDatabase(Database database) async {
    //Config names
    String subjectsTableName = DatabaseConfig.subjectsTableName;
    String imagesTableName = DatabaseConfig.imagesTableName;
    String usersTableName = DatabaseConfig.usersTableName;
    String decksTableName = DatabaseConfig.decksTableName;

    await database.execute("DROP TABLE IF EXISTS $subjectsTableName");
    await database.execute("DROP TABLE IF EXISTS $imagesTableName");
    await database.execute("DROP TABLE IF EXISTS $usersTableName");
    await database.execute("DROP TABLE IF EXISTS $decksTableName");
    await database.execute("DROP TABLE IF EXISTS $decksTableName");
  }

  //Init database
  Future<void> initDb() async {
    db = await openDatabase(
      configDb.databasePath,
      version: 8,
      onCreate: (db, version) {
        db.execute(configDb.initSubjects);
        db.execute(configDb.initImages);
        db.execute(configDb.initUsers);
        db.execute(configDb.initDecks);
        db.execute(configDb.initFlashcards);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await clearDatabase(db);
        await db.execute(configDb.initSubjects);
        await db.execute(configDb.initImages);
        await db.execute(configDb.initUsers);
        await db.execute(configDb.initDecks);
        await db.execute(configDb.initFlashcards);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("rememberUser", false);
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        await clearDatabase(db);
        await db.execute(configDb.initSubjects);
        await db.execute(configDb.initImages);
        await db.execute(configDb.initUsers);
        await db.execute(configDb.initDecks);
        await db.execute(configDb.initFlashcards);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("rememberUser", false);
      },
    );
  }
}
