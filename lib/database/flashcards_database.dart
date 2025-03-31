part of 'main_database.dart';

extension FlashcardsDatabase on DatabaseService {
  Future<String> saveFlashcardFile(String fileContent) async {
    final String path = configDb.flascardsFileDirectory;

    final String fileName = DateTime.now().toString();
    final String filePath = "$path/$fileName.json";

    await File(filePath).writeAsString(fileContent);

    return filePath;
  }

  Future<void> updateFlashcardFile(String filePath, String fileContent) async {
    await File(filePath).writeAsString(fileContent);
  }

  Future<void> deleteFlashcardFile(String filePath) async => await File(filePath).delete();

  //FLashcards
  Future<FlashcardModel> insertFlashcard({
    required int deckId,
    required String flashcardFrontContent,
    required String flashcardBackContent,
  }) async {
    final String flashcardFrontPath =
        await saveFlashcardFile(flashcardFrontContent);

    final String flashcardBackPath =
        await saveFlashcardFile(flashcardBackContent);

    final int flashcardId = await db.insert(DatabaseConfig.flashcardTableName, {
      DatabaseConfig.flashcardDeckIdColumn: deckId,
      DatabaseConfig.flashcardFrontPathColumn: flashcardFrontPath,
      DatabaseConfig.flashcardBackPathColumn: flashcardBackPath,
    });

    return FlashcardModel(
        flashcardId: flashcardId,
        deckId: deckId,
        flashcardFrontPath: flashcardFrontPath,
        flashcardBackPath: flashcardBackPath);
  }

  Future<List<FlashcardModel>> getFlashcards({required int deckId}) async {
    String flashcardDeckIdColumn = DatabaseConfig.flashcardDeckIdColumn;

    final data = await db.query(DatabaseConfig.flashcardTableName,
        where: "$flashcardDeckIdColumn = ?", whereArgs: [deckId]);
    
    return data.map((e) => FlashcardModel.fromMap(e)).toList();
  }

  Future<void> deleteFlashcard(FlashcardModel flashcard) async {
    String flashcardIdColumn = DatabaseConfig.flashcardIdColumn;

    await db.delete(
      DatabaseConfig.flashcardTableName,
      where: "$flashcardIdColumn = ?",
      whereArgs: [flashcard.flashcardId],
    );

    await deleteFlashcardFile(flashcard.flashcardFrontPath);
    await deleteFlashcardFile(flashcard.flashcardBackPath);
  }

  Future<void> editFlashcard({
    required FlashcardModel flashcard,
    required String newFlashcardFrontContent,
    required String newFlashcardBackContent,
  }) async {
    await updateFlashcardFile(flashcard.flashcardFrontPath, newFlashcardFrontContent);
    await updateFlashcardFile(flashcard.flashcardBackPath, newFlashcardBackContent);
  }
}
