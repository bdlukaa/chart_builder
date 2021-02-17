import 'package:flutter/material.dart';
import 'package:get_localization/get_localization.dart';

export 'package:get_localization/get_localization.dart';
export 'languages/en.dart';

abstract class BaseLocalization extends Localization {
  BaseLocalization({
    @required String code,
    @required String name,
    String country,
  }) : super(
          code: code,
          name: name,
          country: country,
        );

  String get appTitle;
  
  // Settings
  String get settings;
  // Theme
  String get appTheme;
  String themeName(ThemeMode mode);
  // Language
  String get language;

  // Buttons
  String get newButton;
  String get undo;

  String get noChartsCreated;
  String get noLineChartsCreated;
  String get noBarChartsCreated;
  String get noPieChartsCreated;
  String get noScatterChartsCreated;

}
