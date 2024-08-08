import 'package:flutter/material.dart';
import 'package:pro_graduacion/theme/tema.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool _istheme = false;


  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  
  void toggleTheme() {
    if (_themeData == lightMode) {
      _istheme = true;
      themeData = darkMode;
    } else {
       _istheme = false;
      themeData = lightMode;
    }
    // print(istheme);
    // notifyListeners();
  }
    bool get istheme => _istheme;
}
