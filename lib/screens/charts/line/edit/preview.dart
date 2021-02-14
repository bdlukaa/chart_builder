import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../models/chart.dart';

class Preview extends StatelessWidget {
  const Preview({Key key, @required this.chart}) : super(key: key);

  final Chart chart;

  @override
  Widget build(BuildContext context) {
    return LineChart(chart.data);
  }
}