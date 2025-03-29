
import 'dart:io';

class FlashcardModel {
  final int flashcardId;
  final int deckId;
  String flashcardFrontPath;
  String flashcardBackPath;

  FlashcardModel({
    required this.flashcardId,
    required this.deckId,
    required this.flashcardFrontPath,
    required this.flashcardBackPath
  });

  Map<String, dynamic> toMap() {
    return {
      "flashcardId": flashcardId,
      "deckId": deckId,
      "flashcardFrontPath": flashcardFrontPath,
      "flashcardBackPath": flashcardBackPath
    };
  }

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      flashcardId: map["flashcardId"], 
      deckId: map["deckId"], 
      flashcardFrontPath: map["flashcardFrontPath"], 
      flashcardBackPath: map["flashcardBackPath"]
    );
  }

}