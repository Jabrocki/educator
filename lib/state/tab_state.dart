import 'package:flutter/material.dart';

class TabState extends ChangeNotifier {
  int _activeTabIndex = 0;

  int get activeTabIndex => _activeTabIndex;

  set activeTabIndex(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  //Subject navigator
  
  String? _subjectRouteName;

  set subjectRouteName(String? subjectRouteName) {
    _subjectRouteName = subjectRouteName;
    notifyListeners();
  }

  String? get subjectRouteName => _subjectRouteName;

}
