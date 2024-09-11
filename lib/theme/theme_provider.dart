import 'package:flutter/material.dart';
import 'package:pro_graduacion/theme/tema.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool _istheme = false;
  bool get istheme => _istheme;

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
  }

  Future<void> inicializarTema() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? tres = prefs.getInt("them") == 1 ? true : false;
    if (tres == true) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
