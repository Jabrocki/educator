//Database
import '../database/main_database.dart';

import 'package:flutter/material.dart';

//Models
import '../models/deck_model.dart';
import '../models/image_model.dart';

import 'dart:io';

class DeckListState extends ChangeNotifier {
  //List of flashcard decks
  late List<DeckModel> _decks;

  List<DeckModel> get decks => _decks;

  //Database service
  final DatabaseService _instance = DatabaseService.instance;

  //Flag to check if we are editing or adding card deck
  bool _isEditing = false;

  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  bool get isEditing => _isEditing;

  //Deck add name text editing controller
  final TextEditingController deckNameController = TextEditingController();
  final TextEditingController deckNumberLearnController =
      TextEditingController();
  final TextEditingController deckNumberReviewController =
      TextEditingController();

  //Deck edit getters
  String get deckName => deckNameController.text;

  set deckName(String deckName) {
    deckNameController.text = deckName;
    notifyListeners();
  }

  int get maximumNumberOfCardsToLearn => deckNumberLearnController.text as int;

  set maximumNumberOfCardsToLearn(int maximumNumberOfCardsToLearn) {
    deckNumberLearnController.text = maximumNumberOfCardsToLearn.toString();
    notifyListeners();
  }

  int get maximumNumberOfCardsToReview =>
      deckNumberReviewController.text as int;

  set maximumNumberOfCardsToReview(int maximumNumberOfCardsToReview) {
    deckNumberReviewController.text = maximumNumberOfCardsToReview.toString();
    notifyListeners();
  }

  //Image edited data
  int? _imgId;
  File? _imgFile;

  set imgFile(File? imgFile) {
    _imgFile = imgFile;
    notifyListeners();
  }

  set imgId(int? imgId) {
    _imgId= imgId;
    notifyListeners();
  }

  int? get imgId => _imgId;
  File? get imgFile => _imgFile;

  //Edited deck data
  int? _editedDeckId;

  set editedDeckId(int? editedDeckId) {
    _editedDeckId = editedDeckId;
    notifyListeners();
  }

  int? get editedDeckId => _editedDeckId;

  //Subject data
  late int _subjectId;
  int get subjectId => _subjectId;

  //Downloads all decks and inits userId
  Future<bool> decksInit(int subjectId) async {
    //Inits subjects
    _subjectId = subjectId;
    _decks = await _instance.getDecks(subjectId: subjectId);
    notifyListeners();
    return true;
  }

  //Deck handle methods
  void addDeck() async {
    if (imgFile != null) {
      imgId = await _instance.saveAndInsertImage(imgFile!);
    }
    int deckId = await _instance.insertDeck(
        subjectId: subjectId,
        deckName: deckName,
        maximumNumberOfCardsToLearn: maximumNumberOfCardsToLearn,
        maximumNumberOfCardsToReview: maximumNumberOfCardsToReview,
        numberOfCardsNew: 0,
        numberOfCardsLearn: 0,
        numberOfCardsReview: 0,
        imgId: imgId);
    _decks.add(DeckModel(
        deckId: deckId,
        subjectId: subjectId,
        deckName: deckName,
        maximumNumberOfCardsToLearn: maximumNumberOfCardsToLearn,
        maximumNumberOfCardsToReview: maximumNumberOfCardsToReview,
        numberOfCardsNew: 0,
        numberOfCardsLearn: 0,
        numberOfCardsReview: 0,
        imgId: imgId));
    clearAddData();
    notifyListeners();
  }

  void deleteDeck({required int deckId}) async {
    await _instance
        .deleteDeck(_decks.firstWhere((deck) => deck.deckId == deckId));
    _decks.removeWhere((deck) => deck.deckId == deckId);
    notifyListeners();
  }

  void editDeck() async {
    //Get deck model to edit
    DeckModel deck = _decks.firstWhere((deck) => deck.deckId == _editedDeckId);

    //Delete old image if exists
    if (deck.imgId != null) {
      ImageModel oldImage = (await deck.imgModel)!;
      await _instance.deleteImage(oldImage);
    }

    //Upload new image
    deck.imgId = null;
    if (imgFile != null) {
      deck.imgId = await _instance.saveAndInsertImage(imgFile!);
    }

    //Update rest of data
    deck.deckName = deckName;
    deck.maximumNumberOfCardsToLearn = maximumNumberOfCardsToLearn;
    deck.maximumNumberOfCardsToReview = maximumNumberOfCardsToReview;

    //Update database
    await _instance.editDeck(deck);

    //Clear add data
    clearAddData();

    //Notify listners
    notifyListeners();
  }

  //Clear image data
  void clearAddImage() {
    if (_imgFile != null) {
      _imgFile = null;
    }
    notifyListeners();
  }

  //Clear data of custom pop add
  void clearAddData() {
    deckName = '';
    editedDeckId = null;
    maximumNumberOfCardsToLearn = 0;
    maximumNumberOfCardsToReview = 0;
    imgFile = null;
    isEditing = false;
  }
}
