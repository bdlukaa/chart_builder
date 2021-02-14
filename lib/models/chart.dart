import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

typedef OnEditChart<T extends BaseChartData> = Function(Chart<T> chart);

enum ChartType { line, bar, pie }

class Chart<T extends BaseChartData> {
  /// Unique id
  String id;

  String name;
  T data;
  Color backgroundColor;

  Chart({
    @required this.name,
    @required this.data,
    this.backgroundColor = Colors.white,
    this.id,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  /// Create a copy of this object
  Chart<T> createCopy() {
    return Chart(
      id: id,
      name: name,
      data: data,
    );
  }

  bool isSameAs(Chart<T> chart) {
    if (chart == null) return false;
    return chart.data == data && chart.name == name && chart.id == id;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // static Chart fromJson(Map<String, dynamic> json) {
  //   return Chart(
  //     id: json['id'],
  //     // datas:
  //   );
  // }

}

class ChartNotifier<T extends BaseChartData> extends ChangeNotifier {
  List<Chart<T>> charts = [];

  Chart<T> getChart(String id) => charts.firstWhere(
        (e) => e.id == id,
        orElse: () => null,
      );

  void create(Chart<T> chart) {
    charts.add(chart);
    notifyListeners();
  }

  void update(Chart<T> data) {
    final index = charts.indexOf(getChart(data.id));
    charts.removeAt(index);
    charts.insert(index, data);
    notifyListeners();
  }

  void delete(Chart<T> data) {
    charts.remove(data);
    notifyListeners();
  }

  void notify() => notifyListeners();
}

class LineCharts extends ChartNotifier<LineChartData> {}

class BarCharts extends ChartNotifier<BarChartData> {}

class PieCharts extends ChartNotifier<PieChartData> {}
