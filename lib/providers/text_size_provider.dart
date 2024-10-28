import 'package:flutter/material.dart';

class TextSizeProvider with ChangeNotifier {
  double _minTextSize;

  TextSizeProvider(this._minTextSize);

  double get minTextSize => _minTextSize;

  // Method to update the minimum text size
  void updateTextSize(double newSize) {
    if (newSize != _minTextSize) { // Ensure size is different before updating
      _minTextSize = newSize;
      notifyListeners(); // Notify listeners about the change
    }
  }

  // Method to get a relative size based on the minimum text size
  double getRelativeTextSize(double multiplier) {
    return _minTextSize * multiplier;
  }
}
