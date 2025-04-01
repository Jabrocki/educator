import 'dart:io';

//External packges
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConfig {
  //Singelton
  static final DatabaseConfig configDb = DatabaseConfig._constructor();
  DatabaseConfig._constructor();

  late String imageFileFolder;
  late String flascardsFileDirectory;
  late String notesFileDirectory;
  late String otherFilesDirectory;

  //Databasename
  static String databaseName = "database.db";
  late String databaseDirPath;
  late String databasePath ;
  

  //Subjects
  static String subjectsTableName = "subjects";
  static String subjectsIdColumn = "subjectId";
  static String subjectsUserIdColumn = "userId";
  static String subjectNameColumn = "subjectName";
  static String subjectImgIdColumn = "imgId";

  final String initSubjects = """
  CREATE TABLE $subjectsTableName (
    $subjectsIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $subjectsUserIdColumn INTEGER NOT NULL,
    $subjectNameColumn TEXT NOT NULL,
    $subjectImgIdColumn INTEGER
  )
  """;

 //Images
  static String imagesTableName = "images";
  static String imagesIdColumn = "imgId";
  static String imagesFilePathColumn = "imgFilePath";

  final String initImages = """
  CREATE TABLE $imagesTableName (
    $imagesIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $imagesFilePathColumn TEXT NOT NULL
  )
  """;

 //Users
  static String usersTableName = "users";
  static String userIdColumn = "userId";
  static String userNameColumn = "userName";
  static String userPasswordColumn = "userPassword";

  final String initUsers = """
  CREATE TABLE $usersTableName (
    $userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $userNameColumn TEXT NOT NULL,
    $userPasswordColumn TEXT NOT NULL
  )
  """;

//Flashcard decks
  static String decksTableName = "decks";
  static String deckIdColumn = "deckId";
  static String deckSubjectIdColumn = "subjectId";
  static String deckNameColumn = "deckName";
  static String deckMaximumNumberOfCardsToLearn = "maximumNumberOfCardsToLearn";
  static String deckMaximumNumberOfCardsToReview =
      "maximumNumberOfCardsToReview";
  static String deckNumberOfCardsNewColumn = "numberOfCardsNew";
  static String deckNumberOfCardsLearnColumn = "numberOfCardsLearn";
  static String deckNumberOfCardsReviewColumn = "numberOfCardsReview";
  static String deckImgIdColumn = "imgId";

  final String initDecks = """
  CREATE TABLE $decksTableName (
    $deckIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $deckSubjectIdColumn INTEGER NOT NULL,
    $deckNameColumn TEXT NOT NULL,
    $deckMaximumNumberOfCardsToLearn INTEGER NOT NULL,
    $deckMaximumNumberOfCardsToReview INTEGER NOT NULL,
    $deckNumberOfCardsNewColumn INTEGER NOT NULL,
    $deckNumberOfCardsLearnColumn INTEGER NOT NULL,
    $deckNumberOfCardsReviewColumn INTEGER NOT NULL,
    $deckImgIdColumn INTEGER
  )
  """;

  //Flashcards
  static String flashcardTableName = "flashcards";
  static String flashcardIdColumn = "flashcardId";
  static String flashcardDeckIdColumn = "deckId";
  static String flashcardFrontPathColumn = "flashcardFrontPath";
  static String flashcardBackPathColumn = "flashcardBackPath";

  final String initFlashcards = """
  CREATE TABLE $flashcardTableName (
    $flashcardIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $flashcardDeckIdColumn INTEGER NOT NULL,
    $flashcardFrontPathColumn STRING NOT NULL,
    $flashcardBackPathColumn STRING NOT NULL
  )
  """;

  Future<void> initConfig() async {
    String documentsPath = (await getApplicationDocumentsDirectory()).path;

    databaseDirPath = await getDatabasesPath();
    databasePath = join(databaseDirPath, databaseName);


    //Init paths
    imageFileFolder = "$documentsPath/images";
    flascardsFileDirectory = "$documentsPath/flashcards";
    notesFileDirectory = "$documentsPath/notes";
    otherFilesDirectory = "$documentsPath/other";

    await Directory(imageFileFolder).create();
    await Directory(flascardsFileDirectory).create();
    await Directory(notesFileDirectory).create();
    await Directory(otherFilesDirectory).create();
  }
}
