import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';

import 'chart_database.dart';

typedef OnEditChart<T extends BaseChartData> = Function(Chart<T> chart);

enum ChartType { line, bar, pie, scatter }

class Chart<T extends BaseChartData> {
  /// Unique id
  final String id;

  String name;
  T data;
  Color backgroundColor;

  Chart({
    @required this.name,
    @required this.data,
    this.backgroundColor = Colors.white,
    String id,
  }) : this.id = id ?? Uuid().v1();

  /// Create a copy of this object
  Chart createCopy() {
    if (T == PieChartData) {
      return Chart<PieChartData>(
        id: id,
        name: name,
        data: (data as PieChartData).copyWith(
          startDegreeOffset:
              (data as PieChartData).startDegreeOffset.toDouble(),
          sectionsSpace: (data as PieChartData).sectionsSpace.toDouble(),
          centerSpaceColor:
              (data as PieChartData).centerSpaceColor?.withOpacity(1),
          centerSpaceRadius:
              (data as PieChartData).centerSpaceRadius.toDouble(),
          sections: (data as PieChartData).sections.toList(),
        ),
      );
    }
    return Chart<T>(
      id: id,
      name: name,
      data: data,
    );
  }

  bool isSameAs(Chart<T> chart) {
    // return false;
    if (chart == null) return false;
    final isSame = chart.data == data &&
        chart.name == name &&
        chart.id == id &&
        chart.backgroundColor == backgroundColor;
    if (T == PieChartData) {
      // final pieChart = chart as Chart<PieChartData>;
      // final data = this.data as PieChartData;
      return isSame;
    }
    return isSame;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LineCharts {}

class BarCharts {}

class PieCharts {
  static void create(Chart<PieChartData> chart) {
    ChartDatabase.pieChartsBox.put(chart.id, _encodePieChart(chart));
  }

  static Future update(Chart<PieChartData> data) {
    return ChartDatabase.pieChartsBox.put(data.id, _encodePieChart(data));
  }

  static void delete(Chart<PieChartData> data) {
    ChartDatabase.pieChartsBox.delete(data.id);
  }

  static Chart<PieChartData> decodePieChart(
    String id,
    Map map,
  ) {
    final data = map['data'];
    final sections = data['sections'];
    return Chart(
      id: id,
      name: map['name'],
      backgroundColor: _parseColor(map['backgroundColor']),
      data: PieChartData(
        centerSpaceColor: _parseColor(data['centerSpaceColor']),
        centerSpaceRadius: data['centerSpaceRadius'],
        sectionsSpace: data['sectionsSpace'],
        startDegreeOffset: data['startDegreeOffset'],
        borderData: FlBorderData(
          show: data['border']['show'],
          border: Border.all(
            color: _parseColor(data['border']['color']),
            width: data['border']['width'],
          ),
        ),
        sections: List.generate(sections.length, (index) {
          final section = sections[index];
          return PieChartSectionData(
            color: _parseColor(section['color']),
            radius: section['radius'],
            value: section['value'],
            showTitle: section['showTitle'],
            title: section['title'],
          );
        }),
      ),
    );
  }

  static Map<String, dynamic> _encodePieChart(Chart<PieChartData> chart) {
    final data = chart.data;
    return {
      'name': chart.name,
      'backgroundColor': chart.backgroundColor.hex,
      'data': {
        'centerSpaceColor': data.centerSpaceColor.hex,
        'centerSpaceRadius': data.centerSpaceRadius,
        'sectionsSpace': data.sectionsSpace,
        'startDegreeOffset': data.startDegreeOffset,
        'border': {
          'show': data.borderData.show,
          'color': data.borderData.border?.top?.color?.hex,
          'width': data.borderData.border?.top?.width,
        },
        'sections': List.generate(data.sections.length, (index) {
          final section = data.sections[index];
          return {
            'color': section.color.hex,
            'radius': section.radius,
            'value': section.value,
            'showTitle': section.showTitle,
            'title': section.title,
          };
        }),
      }
    };
  }
}

extension _colorHex on Color {
  String get hex => value.toRadixString(16);
}

Color _parseColor(String hex) {
  if (hex == null) return null;
  return Color(int.parse('0x$hex'));
}
