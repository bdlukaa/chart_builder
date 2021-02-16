import 'dart:math';

import 'package:flutter/material.dart';
import '../models/settings.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode get mode => Settings.theme;
  set mode(ThemeMode mode) {
    Settings.setTheme(mode).then((value) {
      notifyListeners();
    });
  }

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  ThemeData def(ThemeData from) => from.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
      );

  ThemeData get lightTheme => def(ThemeData.light()).copyWith();
  ThemeData get darkTheme => def(ThemeData.dark()).copyWith(
        accentColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}

String nameThemeMode(ThemeMode mode) {
  final name = mode.toString().replaceAll('ThemeMode.', '');
  return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
}

List<Color> get colors => [
      ...Colors.primaries,
      ...Colors.accents,
    ];

extension list<T> on List<T> {
  T random() {
    final index = Random().nextInt(this.length - 1);
    return this[index];
  }
}

extension contextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
}
