//Material
import 'package:flutter/material.dart';

//Database
import '../database/main_database.dart';

//Models
import '../models/image_model.dart';
import '../models/subject_model.dart';

class SubjectState extends ChangeNotifier {
  //List of subjects
  late List<SubjectModel> _subjects;

  List<SubjectModel> get subjects => _subjects;

  //Database service
  final DatabaseService _instance = DatabaseService.instance;

  //User data
  int? _userId;

  set userId(int? userId) {
    _userId = userId;
    notifyListeners();
  }

  int? get userId => _userId;

  //Downloads all subjects of login user
  Future<bool> subjectInit() async {
    _subjects = await _instance.getSubjects(userId: userId!);
    return true;
  }

  //Subject handle methods
  void addSubject({
    required int userId,
    required String subjectName,
    int? imgId,
  }) async {
    int subjectId = await _instance.insertSubject(
        userId: userId, subjectName: subjectName, imgId: imgId);
    _subjects.add(SubjectModel(
        subjectId: subjectId,
        userId: userId,
        subjectName: subjectName,
        imgId: imgId));
    notifyListeners();
  }

  void deleteSubject({required int subjectId}) async {
    await _instance.deleteSubject(
        _subjects.firstWhere((subject) => subject.subjectId == subjectId));
    _subjects.removeWhere((subject) => subject.subjectId == subjectId);
    notifyListeners();
  }

  void editSubject({
    required int subjectId,
    required String subjectName,
    int? imgId,
  }) async {
    //Get subject to edit
    SubjectModel subject =
        _subjects.firstWhere((subject) => subject.subjectId == subjectId);

    //Delete old image if exists
    if (subject.imgId != null) {
      ImageModel oldImage = (await subject.imgModel)!;
      await _instance.deleteImage(oldImage);
    }

    //Upload new image
    subject.imgId = imgId;

    //Change subject name
    subject.subjectName = subjectName;

    //Update database
    await _instance.editSubject(subject);

    //Notify listeners
    notifyListeners();
  }
  

}
