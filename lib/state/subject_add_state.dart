import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/main_database.dart';

class SubjectAddState extends ChangeNotifier {
  File? _imgFile;
  String? _subjectName;
  final TextEditingController _subjectNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final DatabaseService _instance = DatabaseService.instance;
  bool _isEditing = false;
  int? _subjectId;

  File? get imgFile => _imgFile;
  TextEditingController get subjectNameController => _subjectNameController;

  int get subjectId => _subjectId!;
  bool get isEditing => _isEditing;

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

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) _imgFile = File(pickedImage.path);
    } catch (e) {
      print("Error");
    }
    notifyListeners();
  }

  Future<int?> saveImage() async {
    if (_imgFile != null) {
      return _instance.saveAndInsertImage(_imgFile!);
    }
    return null;
  }

  void clearImage() {
    if (_imgFile != null) {
      _imgFile = null;
    }
    notifyListeners();
  }

  void clearData() {
    _imgFile = null;
    _subjectNameController.text = '';
    _subjectName = null;
    _subjectId = null;
    _isEditing = false;
    notifyListeners();
  }
}
