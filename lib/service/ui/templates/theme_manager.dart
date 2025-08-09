import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeManager() {
    loadTheme();
  }

  void setTheme(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.name);
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode');

    if (themeStr != null) {
      //
      themeMode = ThemeMode.values.firstWhere((e) => e.name == themeStr);
      notifyListeners();
    }
  }
}
