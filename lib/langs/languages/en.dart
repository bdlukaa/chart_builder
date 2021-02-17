import 'package:flutter/material.dart';

import '../lang.dart';

class EnglishLocalization extends BaseLocalization {
  EnglishLocalization() : super(code: 'en', name: 'English');

  String get appTitle => 'Chart Builder';

  // Settings
  String get settings => 'Settings';
  // Theme
  String get appTheme => 'Theme';
  String themeName(ThemeMode mode) {
    final name = mode.toString().replaceAll('ThemeMode.', '');
    return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
  }

  // Language
  String get language => 'Language';

  // Buttons
  String get newButton => 'New';
  String get undo => 'UNDO';

  String get noChartsCreated => 'You have no charts created.';
  String get noLineChartsCreated => 'You have no line charts created.';
  String get noBarChartsCreated => 'You have no bar charts created.';
  String get noPieChartsCreated => 'You have no pie charts created.';
  String get noScatterChartsCreated => 'You have no scatter charts created.';
}
