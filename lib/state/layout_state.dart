import "package:flutter/material.dart";

class LayoutState extends ChangeNotifier {
  //Width
  double _width = 0.0;
  int _crossAxisCount = 0;

  void updateMaxWidth(double newWidth)  {
    if (_width != newWidth) {
      _width = newWidth;
      notifyListeners();
    }
  }

  void updateCrossAxisCount(int crossAxisCount) {
    if (_crossAxisCount != crossAxisCount) {
      _crossAxisCount = crossAxisCount;
      notifyListeners();
    }
  }


  double get width => _width;
  double get refernceGridSize {
    return _width/_crossAxisCount;
  }
  int get crossAxisCount => _crossAxisCount;
}