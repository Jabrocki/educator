//Image model
import '../models/image_model.dart';

//Database
import '../database/main_database.dart';

//Files
import 'dart:io';

class SubjectModel {
  final int subjectId;
  final int userId;
  String subjectName;
  int? imgId;

  SubjectModel(
      {required this.subjectId,
      required this.userId,
      required this.subjectName,
      this.imgId});

  Map<String, dynamic> toMap() {
    return {
      "subjectId": subjectId,
      "userId": userId,
      "subjectName": subjectName,
      "imgId": imgId
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
        subjectId: map['subjectId'],
        userId: map['userId'],
        subjectName: map['subjectName'],
        imgId: map['imgId']);
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
    Subject{
    subjectId: $subjectId, userId: $userId,
    subjectName: $subjectName, imgId: $imgId
    }
    """;
  }
}
