import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> getIntData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
