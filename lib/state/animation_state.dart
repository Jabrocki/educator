import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {
  bool _reAnimate = false;

  int _selectedIndex = 0;

  set reAnimate(bool reAnimate) {
    _reAnimate = reAnimate;
    notifyListeners();
  }

  set selectedIndex(int selectedIndex) {
    if (_selectedIndex != selectedIndex) {
      _selectedIndex = selectedIndex;
      _reAnimate = true;
      notifyListeners();
    }
  }

  bool get reAnimate => _reAnimate;
  int get selectedIndex => _selectedIndex;
}
