import 'package:flutter/material.dart';
import 'package:get_localization/get_localization.dart';

import '../models/chart.dart';

export 'package:get_localization/get_localization.dart';
export 'languages/en.dart';
export 'languages/pt.dart';

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

  String get flag;
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

  String get save;
  String get back;
  String get delete;

  String get add;

  String get editButton;
  String get cancel;
  String get done;

  String get takeScreenshot;
  String get bookmark;

  // New chart
  String get newChart;
  String get newLineChart;
  String get newBarChart;
  String get newPieChart;
  String get newScatterChart;
  String chartGeneratedName(ChartType type, int number);

  String get chartName;

  String get create;

  // Errors
  String get canNotBeEmpty;

  // General Charts
  String get backgroundColor;
  String get border;
  String get borderColor;
  String get borderWidth;

  String get value;

  String get edit;
  String get preview;

  String saved(String name);
  String deleted(String name);

  String get options;

  // Danger zone
  String get dangerZone;

  String get deleteThisChart;
  String get deleteThisChartDesc;

  // Pie charts
  String get centerSpaceRadius;
  String get centerSpaceColor;
  String get rotationDegree;
  String get sectionsSpace;

  String get sections;

  String get center;

  // Pie charts/sections
  String get title;
  String get sectionColor;
  String get radius;
  String get showTitle;
  String get titlePosition;

  // Leave dialog
  String get areYouSure;
  String get areYouSureDescription;

  String get leave;
  String get saveAndLeave;
  String get dismiss;

  // Hints
  String get slideToSideToDeleteSection;
  String get longPressSectionToEdit;
  String get longPressChartToOptions;
}
