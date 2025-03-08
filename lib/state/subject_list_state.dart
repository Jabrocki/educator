//Material
import 'package:flutter/material.dart';

//Database
import '../database/main_database.dart';

//Models
import '../models/image_model.dart';
import '../models/subject_model.dart';

//External packages
import 'package:image_picker/image_picker.dart';

//Internal packages
import 'dart:io';

class SubjectListState extends ChangeNotifier {
  //List of subjects
  late List<SubjectModel> _subjects;

  List<SubjectModel> get subjects => _subjects;

  //Database service
  final DatabaseService _instance = DatabaseService.instance;

  //Subject add name text editing controller
  final TextEditingController _subjectNameController = TextEditingController();

  //Image picker
  final ImagePicker _picker = ImagePicker();

  //User data
  int? _userId;

  set userId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  int get userId => _userId!;

  //Downloads all subjects of login user
  Future<bool> subjectInit() async {
    _subjects = await _instance.getSubjects(userId: userId);
    return true;
  }

  //Subject handle methods
  void addSubject({
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

  File? _imgFile;
  String? _subjectName;

  bool _isEditing = false;
  int? _subjectId;

  //Getters
  File? get imgFile => _imgFile;
  TextEditingController get subjectNameController => _subjectNameController;
  int get subjectId => _subjectId!;
  bool get isEditing => _isEditing;

  //Setters
  set imgFile(File? imgFile) {
    _imgFile = imgFile;
    notifyListeners();
  }

  set subjectName(String? subjectName) {
    _subjectName = subjectName;
    _subjectNameController.text = _subjectName!;
    notifyListeners();
  }

  set subjectId(int subjectId) {
    _subjectId = subjectId;
    notifyListeners();
  }

  set isEditing(bool isEditing) {
    _isEditing = isEditing;
    notifyListeners();
  }

  Future<void> pickAddImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) _imgFile = File(pickedImage.path);
    } catch (e) {
      print("Error");
    }
    notifyListeners();
  }

  Future<int?> saveAddImage() async {
    if (_imgFile != null) {
      return _instance.saveAndInsertImage(_imgFile!);
    }
    return null;
  }

  void clearAddImage() {
    if (_imgFile != null) {
      _imgFile = null;
    }
    notifyListeners();
  }

  void clearAddData() {
    _imgFile = null;
    _subjectNameController.text = '';
    _subjectName = null;
    _subjectId = null;
    _isEditing = false;
    notifyListeners();
  }
}
