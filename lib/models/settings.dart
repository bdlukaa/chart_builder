import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../langs/lang.dart';

class Settings {
  static Future<void> open() => Hive.openBox('settings');
  static Box get _box => Hive.box('settings');

  static Localization get currentLanguage {
    if (!_box.containsKey('currentLanguage')) {
      _box.put('currentLanguage', Localization.currentLocalization.code);
      return Localization.currentLocalization;
    }
    return Localization.getByCode(_box.get('currentLanguage'));
  }

  static set currentLanguage(Localization loc) {
    _box.put('currentLanguage', loc.code);
  }

  static ThemeMode get theme =>
      _parseThemeMode(_box.get('themeMode')) ?? ThemeMode.system;
  static Future<void> setTheme(ThemeMode mode) {
    return _box.put('themeMode', mode.toString());
  }
}

ThemeMode _parseThemeMode(String text) {
  if (text == null) return null;
  return ThemeMode.values.firstWhere((e) => text == e.toString());
}
