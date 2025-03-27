part of 'main_database.dart';

extension FlashcardsDatabase on DatabaseService {
  Future<String> saveFlashcardFile(String flashCard) async {
    return '';
  }

  Future<int> insertFlashcard({
    required int deckId,
    required String flashcardFront,
    required String flashcardBack
  }
  ) async {
    return -1;
  }
}