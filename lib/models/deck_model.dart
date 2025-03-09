//Image model
import 'image_model.dart';

//Database
import '../database/main_database.dart';

//Files etc.
import 'dart:io';

class DeckModel {
  final int deckId;
  final int subjectId;
  String deckName;
  int numberOfCardsNew;
  int numberOfCardsLearn;
  int numberOfCardsReview;
  int? imgId;

  DeckModel(
      {required this.deckId,
      required this.subjectId,
      required this.deckName,
      required this.numberOfCardsNew,
      required this.numberOfCardsLearn,
      required this.numberOfCardsReview,
      this.imgId});

  Map<String, dynamic> toMap() {
    return {
      "deckId": deckId,
      "subjectId": subjectId,
      "deckName": deckName,
      "numberOfCardsNew": numberOfCardsNew,
      "numberOfCardsLearn": numberOfCardsLearn,
      "numberOfCardsReview": numberOfCardsReview,
      "imgId": imgId
    };
  }

  factory DeckModel.fromMap(Map<String, dynamic> map) {
    return DeckModel(
        deckId: map["deckId"],
        subjectId: map["subjectId"],
        deckName: map["deckName"],
        numberOfCardsNew: map["numberOfCardsNew"],
        numberOfCardsLearn: map["numberOfCardsLearn"],
        numberOfCardsReview: map["numberOfCardsReview"],
        imgId: map["imgId"]);
  }

  Future<String?> get imgPath async {
    if (imgId != null) {
      DatabaseService instance = DatabaseService.instance;
      return await instance.getImagePath(imgId!);
    }
    return null;
  }

  Future<File?> get imgFile async {
    if (imgId != null) {
      return File((await imgPath)!);
    }
    return null;
  }
  Future<ImageModel?> get imgModel async {
    if (imgId != null) {
      return ImageModel(imgId: imgId!, imgFileName: (await imgPath)!);
    }
    return null;
  }

  @override
  String toString() {
    return """
    Deck{
    deckId: $deckId, 
    subjectId: $subjectId,
    deckName: $deckName, 
    numberOfCardsNew: $numberOfCardsNew,
    numberOfCardsLearn: $numberOfCardsLearn,
    numberOfCardsReview: $numberOfCardsReview,
    imgId; $imgId,
    }
    """;
  }
}
