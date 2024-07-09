import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  ThemeService() {
    _loadFromPrefs();
  }

  _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkMode = _prefs?.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs?.setBool(key, _darkMode);
  }

  toggleTheme() {
    _darkMode = !_darkMode;
    _saveToPrefs();
    notifyListeners();
  }
}