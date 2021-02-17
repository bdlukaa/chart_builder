import 'package:flutter/material.dart';

import '../lang.dart';
import '../../models/chart.dart';

class EnglishLocalization extends BaseLocalization {
  EnglishLocalization() : super(code: 'en', name: 'English');

  String get flag => 'us';
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

  String get save => 'Save';
  String get back => 'Back';
  String get delete => 'Delete';

  String get add => 'Add';

  String get editButton => 'Edit';
  String get cancel => 'Cancel';
  String get done => 'Done';

  String get takeScreenshot => 'Take a screenshot';
  String get bookmark => 'Bookmark';

  // New chart
  String get newChart => 'New chart';
  String get newLineChart => 'Line';
  String get newBarChart => 'Bar';
  String get newPieChart => 'Pie';
  String get newScatterChart => 'Scatter';
  String chartGeneratedName(ChartType type, int number) {
    switch (type) {
      case ChartType.bar:
        return 'Bar Chart $number';
        break;
      case ChartType.pie:
        return 'Pie Chart $number';
        break;
      case ChartType.line:
        return 'Line Chart $number';
        break;
      case ChartType.scatter:
        return 'Scatter Chart $number';
        break;
      default:
        return 'Chart $number';
    }
  }

  String get chartName => 'Chart name';

  String get create => 'Create';

  // Errors
  String get canNotBeEmpty => 'This can NOT be empty';

  // General Charts
  String get backgroundColor => 'Background color';
  String get border => 'Border';
  String get borderColor => 'Border color';

  String get value => 'Value';

  String get edit => 'Edit';
  String get preview => 'Preview';

  String saved(String name) => '${name ?? Chart} saved';
  String deleted(String name) => '${name ?? 'Chart'} was deleted';

  // Danger zone
  String get dangerZone => 'Danger zone';

  String get deleteThisChart => 'Delete this chart';
  String get deleteThisChartDesc =>
      'Once you delete this chart, there is no going back. Please be certain.';

  // Pie charts
  String get centerSpaceRadius => 'Center space radius';
  String get centerSpaceColor => 'Center space color';
  String get rotationDegree => 'Rotation degree';
  String get sectionsSpace => 'Sections space';

  String get sections => 'Sections';

  String get center => 'Center';

  // Pie charts/sections
  String get title => 'Title';
  String get sectionColor => 'Section Color';
  String get radius => 'Radius';
  String get showTitle => 'Show title';
  String get titlePosition => 'Title position';

  // Leave dialog
  String get areYouSure => 'Are you sure?';
  String get areYouSureDescription =>
      'Are you sure you want to leave without saving your progress?';

  String get leave => 'Leave';
  String get saveAndLeave => 'Save and leave';
  String get dismiss => 'Dismiss';

  // Hints
  String get slideToSideToDeleteSection =>
      'Hint: Slide to any sides to delete a section';
  String get longPressSectionToEdit =>
      'Hint: long a press on a section to edit it';
  String get longPressChartToOptions =>
      'Hint: long press on a chart to see the options';
}
