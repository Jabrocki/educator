import "package:flutter/material.dart";

class LayoutState extends ChangeNotifier {
  //Width
  double _maxWidth = 0.0;

  void updateMaxWidth(double newWidth)  {
    if (_maxWidth != newWidth) {
      _maxWidth = newWidth;
      notifyListeners();
    }
  }

  double get maxWidth => _maxWidth;
}