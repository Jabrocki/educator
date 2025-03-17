part of 'main_database.dart';

extension DecksDatabase on DatabaseService {
  //Decks
  Future<int> insertDeck(
      {required int subjectId,
      required String deckName,
      required int maximumNumberOfCardsToLearn,
      required int maximumNumberOfCardsToReview,
      required int numberOfCardsNew,
      required int numberOfCardsLearn,
      required int numberOfCardsReview,
      int? imgId}) async {
    return await db.insert(DatabaseConfig.decksTableName, {
      DatabaseConfig.deckSubjectIdColumn: subjectId,
      DatabaseConfig.deckNameColumn: deckName,
      DatabaseConfig.deckMaximumNumberOfCardsToLearn:
          maximumNumberOfCardsToLearn,
      DatabaseConfig.deckMaximumNumberOfCardsToReview:
          maximumNumberOfCardsToReview,
      DatabaseConfig.deckNumberOfCardsNewColumn: numberOfCardsNew,
      DatabaseConfig.deckNumberOfCardsLearnColumn: numberOfCardsLearn,
      DatabaseConfig.deckNumberOfCardsReviewColumn: numberOfCardsReview,
      DatabaseConfig.deckImgIdColumn: imgId
    });
  }

  Future<List<DeckModel>> getDecks({required int subjectId}) async {
    //Subject id collumn
    String deckSubjectIdColumn = DatabaseConfig.deckSubjectIdColumn;

    final data = await db.query(DatabaseConfig.decksTableName,
        where: "$deckSubjectIdColumn = ?", whereArgs: [subjectId]);
    return data.map((e) => DeckModel.fromMap(e)).toList();
  }

  Future<void> deleteDeck(DeckModel deck) async {
    //Deck id
    String deckIdColumn = DatabaseConfig.deckIdColumn;

    await db.delete(DatabaseConfig.decksTableName,
        where: '$deckIdColumn = ?', whereArgs: [deck.deckId]);
    if (deck.imgId != null) {
      await deleteImage((await deck.imgModel)!);
    }
  }

  Future<void> editDeck(DeckModel deck) async {
    //Deck id
    String deckIdColumn = DatabaseConfig.deckIdColumn;

    db.update(
        DatabaseConfig.decksTableName,
        {
          DatabaseConfig.deckNameColumn: deck.deckName,
          DatabaseConfig.deckMaximumNumberOfCardsToLearn: deck.maximumNumberOfCardsToLearn,
          DatabaseConfig.deckMaximumNumberOfCardsToReview: deck.maximumNumberOfCardsToReview,
          DatabaseConfig.deckImgIdColumn: deck.imgId
        },
        where: "$deckIdColumn = ?",
        whereArgs: [deck.deckId]);
  }
}
