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
    final database = await db;
    return await database.insert(decksTableName, {
      deckSubjectIdColumn: subjectId,
      deckNameColumn: deckName,
      deckMaximumNumberOfCardsToLearn: maximumNumberOfCardsToLearn,
      deckMaximumNumberOfCardsToReview: maximumNumberOfCardsToReview,
      deckNumberOfCardsNewColumn: numberOfCardsNew,
      deckNumberOfCardsLearnColumn: numberOfCardsLearn,
      deckNumberOfCardsReviewColumn: numberOfCardsReview,
      deckImgIdColumn: imgId
    });
  }

  Future<List<DeckModel>> getDecks({required int subjectId}) async {
    final database = await db;
    final data = await database.query(decksTableName,
        where: "$deckSubjectIdColumn = ?", whereArgs: [subjectId]);
    return data.map((e) => DeckModel.fromMap(e)).toList();
  }

  Future<void> deleteDeck(DeckModel deck) async {
    final database = await db;
    await database.delete(decksTableName,
        where: '$deckIdColumn = ?', whereArgs: [deck.deckId]);
    if (deck.imgId != null) {
      await deleteImage((await deck.imgModel)!);
    }
  }

  Future<void> editDeck(DeckModel deck) async {
    final database = await db;
    database.update(
        decksTableName,
        {
          deckNameColumn: deck.deckName,
          deckMaximumNumberOfCardsToLearn: deck.maximumNumberOfCardsToLearn,
          deckMaximumNumberOfCardsToReview: deck.maximumNumberOfCardsToReview,
          deckImgIdColumn: deck.imgId
        },
        where: "$deckIdColumn = ?",
        whereArgs: [deck.deckId]);
  }
}
