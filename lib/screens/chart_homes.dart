import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:animations/animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/chart.dart';
import '../utils/utils.dart';
import '../utils/theme.dart';
import '../widgets/card_options.dart';
import '../langs/lang.dart';

class ChartHome extends StatefulWidget {
  ChartHome({
    Key key,
    @required this.box,
    @required this.editChart,
    @required this.deleteChart,
    @required this.type,
    this.boxEmptyMessage,
  }) : super(key: key);

  final Box box;
  final String boxEmptyMessage;
  final Function(Chart chart) editChart;
  final Function(Chart chart) deleteChart;
  final ChartType type;

  @override
  _ChartHomeState createState() => _ChartHomeState();
}

class _ChartHomeState extends State<ChartHome> {
  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;

    return ValueListenableBuilder(
      valueListenable: widget.box.listenable(),
      builder: (context, Box box, child) {
        Widget w;
        List<Chart<PieChartData>> charts = [];
        box.toMap().forEach((id, v) {
          charts.add(PieCharts.decodePieChart(id, v));
        });
        if (charts.isEmpty)
          w = Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15),
            child: Text(widget.boxEmptyMessage ?? loc.noChartsCreated),
          );
        else
          w = ListView(children: [
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: computeAmountGridView(
                MediaQuery.of(context).size.width,
                max: charts.length,
              ),
              children: List.generate(charts.length, (index) {
                final chart = charts[index].createCopy();
                return Card(
                  color: chart.backgroundColor,
                  child: InkWell(
                    onLongPress: () {
                      showOptionsSheet(context, () {
                        widget.deleteChart?.call(chart);
                      }, () {
                        widget.editChart?.call(chart);
                      });
                    },
                    onTap: () => widget.editChart?.call(chart),
                    borderRadius: BorderRadius.circular(6),
                    child: AbsorbPointer(
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
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
                            if (widget.type == ChartType.line)
                              Expanded(child: LineChart(chart.data)),
                            if (widget.type == ChartType.bar)
                              Expanded(child: BarChart(chart.data)),
                            if (widget.type == ChartType.pie)
                              Expanded(
                                child: _PieChartPreview(
                                  chart: chart,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            Text(
              loc.longPressChartToOptions,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ]);
        return PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondary) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondary,
            child: child,
          ),
          child: w,
        );
      },
    );
  }
}

class _PieChartPreview extends StatelessWidget {
  const _PieChartPreview({Key key, @required this.chart}) : super(key: key);

  final Chart<PieChartData> chart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, consts) {
        final center =
            consts.biggest.longestSide * (chart.data.centerSpaceRadius / 400);
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: PieChart(
            chart.data.copyWith(
              centerSpaceRadius: center,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(enabled: false),
              sections: chart.data.sections.map((e) {
                var radius =
                    consts.biggest.longestSide * (e.radius / 275) - center;
                return e.copyWith(
                  radius: radius,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
