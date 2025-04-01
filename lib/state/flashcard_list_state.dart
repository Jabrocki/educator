
import 'package:educator/database/main_database.dart';
import 'package:educator/models/flashcard_model.dart';
import 'package:flutter/material.dart';

class FlashcardListState extends ChangeNotifier {
  //List of flashcards
  late int _deckId;

  int get deckId => _deckId;

  set deckId (int deckId) {
    _deckId = deckId;
    notifyListeners();
  }


  late List<FlashcardModel> _flashcards;
  List<FlashcardModel> get flashcards => _flashcards;

  //Database service
  final DatabaseService _instance = DatabaseService.instance;


  Future<void> flashcardsInit() async {
    _flashcards = await _instance.getFlashcards(deckId: _deckId);
    notifyListeners();
  }

  Future<void> addFlashcard() async {
    final flashcard = await _instance.insertFlashcard(deckId: deckId, flashcardFrontContent: '', flashcardBackContent: '');
    _flashcards.add(flashcard);
    notifyListeners();
  }

  Future<void> deleteFlashcard({required FlashcardModel flashcard}) async {
    _flashcards.removeWhere((item) => item.flashcardId == flashcard.flashcardId);
    await _instance.deleteFlashcard(flashcard);
    notifyListeners();
  }
}