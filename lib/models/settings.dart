import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings {
  static Future<void> open() => Hive.openBox('settings');
  static Box get _box => Hive.box('settings');

  static String get currentLanguage => _box.get('currentLanguage');
  static ThemeMode get theme =>
      _parseThemeMode(_box.get('themeMode')) ?? ThemeMode.system;
  static Future<void> setTheme(ThemeMode mode) async {
    return _box.put('themeMode', mode.toString());
  }
}

ThemeMode _parseThemeMode(String text) {
  if (text == null) return null;
  return ThemeMode.values.firstWhere((e) => text == e.toString());
}
