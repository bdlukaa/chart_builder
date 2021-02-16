import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chart.dart';
import '../utils/utils.dart';
import '../utils/theme.dart';

class ChartHome<T extends ChartNotifier> extends StatefulWidget {
  ChartHome({
    Key key,
    @required this.boxName,
    @required this.editChart,
    this.boxEmptyMessage,
  }) : super(key: key);

  final String boxName;
  final String boxEmptyMessage;
  final Function(Chart chart) editChart;

  @override
  _ChartHomeState createState() => _ChartHomeState<T>();
}

class _ChartHomeState<T extends ChartNotifier> extends State<ChartHome> {
  @override
  Widget build(BuildContext context) {
    final charts = context.watch<T>();

    if (charts.charts.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Text(widget.boxEmptyMessage ?? 'You have no charts created.'),
      );
    }
    return GridView.count(
      crossAxisCount: computeAmountGridView(
        MediaQuery.of(context).size.width,
        max: charts.charts.length,
      ),
      children: List.generate(charts.charts.length, (index) {
        final chart = charts.charts[index];
        return Card(
          color: chart.backgroundColor,
          child: InkWell(
            onTap: () => widget.editChart?.call(chart),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: LayoutBuilder(
                builder: (context, consts) => Column(
                  children: [
                    Text(
                      chart?.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (chart.backgroundColor ??
                                        (AppTheme.isDark(context)
                                            ? Colors.grey.shade800
                                            : Colors.white))
                                    .computeLuminance() >=
                                0.5
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    if (T == LineCharts) Expanded(child: LineChart(chart.data)),
                    if (T == BarCharts) Expanded(child: BarChart(chart.data)),
                    if (T == PieCharts)
                      Expanded(
                        child: _PieChartPreview(chart: chart, consts: consts),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PieChartPreview extends StatelessWidget {
  const _PieChartPreview({
    Key key,
    @required this.chart,
    @required this.consts,
  }) : super(key: key);

  final Chart<PieChartData> chart;
  final BoxConstraints consts;

  @override
  Widget build(BuildContext context) {
    final center =
        consts.biggest.longestSide * (chart.data.centerSpaceRadius / 800);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: PieChart(
        chart.data.copyWith(
          centerSpaceRadius: center,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(enabled: false),
          sections: chart.data.sections.map((e) {
            var radius = consts.biggest.longestSide * (e.radius / 250) - center;
            return e.copyWith(
              radius: radius,
              showTitle: false,
            );
          }).toList(),
        ),
      ),
    );
  }
}
