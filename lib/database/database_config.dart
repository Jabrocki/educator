  //Databasename
const String databaseName = "database.db";


//Subjects
const String subjectsTableName = "subjects";
const String subjectsIdColumn = "subjectId";
const String subjectsUserIdColumn = "userId";
const String subjectNameColumn = "subjectName";
const String subjectImgIdColumn = "imgId";

const String initSubjects = """
  CREATE TABLE $subjectsTableName (
    $subjectsIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $subjectsUserIdColumn INTEGER NOT NULL,
    $subjectNameColumn TEXT NOT NULL,
    $subjectImgIdColumn INTEGER
  )
  """;

//Images
const String imagesTableName = "images";
const String imagesIdColumn = "imgId";
const String imagesFilePathColumn = "imgFilePath";

const String initImages = """
  CREATE TABLE $imagesTableName (
    $imagesIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $imagesFilePathColumn TEXT NOT NULL
  )
  """;

//Users
const String usersTableName = "users";
const String userIdColumn = "userId";
const String userNameColumn = "userName";
const String userPasswordColumn = "userPassword";

String initUsers = """
  CREATE TABLE $usersTableName (
    $userIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $userNameColumn TEXT NOT NULL,
    $userPasswordColumn TEXT NOT NULL
  )
  """;

//Flashcard decks
const String decksTableName = "decks";
const String deckIdColumn = "deckId";
const String deckSubjectIdColumn = "subjectId";
const String deckNameColumn = "deckName";
const String deckMaximumNumberOfCardsToLearn = "maximumNumberOfCardsToLearn";
const String deckMaximumNumberOfCardsToReview = "maximumNumberOfCardsToReview";
const String deckNumberOfCardsNewColumn = "numberOfCardsNew";
const String deckNumberOfCardsLearnColumn = "numberOfCardsLearn";
const String deckNumberOfCardsReviewColumn = "numberOfCardsReview";
const String deckImgIdColumn = "imgId";

const String initDecks = """
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
const String flashcardTableName = "flashcards";
const String flashcardIdColumn = "flashcardId";
const String flashcardDeckIdColumn = "deckId";
const String flashcardFrontPathColumn = "flashcardFrontPath";
const String flashcardBackPathColumn = "flashcardBackPath";

const String initFlashcards = """
  CREATE TABLE $flashcardTableName (
    $flashcardIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $flashcardDeckIdColumn INTEGER NOT NULL,
    $flashcardFrontPathColumn STRING NOT NULL,
    $flashcardBackPathColumn STRING NOT NULL
  )
  """;