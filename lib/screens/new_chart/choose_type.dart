import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/chart.dart';
import '../../langs/lang.dart';
import '../../utils/utils.dart';

class ChooseChartType extends StatelessWidget {
  const ChooseChartType({
    Key key,
    @required this.type,
    @required this.onChanged,
  }) : super(key: key);

  final ChartType type;
  final ValueChanged<ChartType> onChanged;

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return GridView.count(
      crossAxisCount: computeAmountGridView(
        MediaQuery.of(context).size.width,
        max: ChartType.values.length,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildCard(loc.newLineChart, Colors.pink, ChartType.line),
        _buildCard(loc.newBarChart, Colors.blue, ChartType.bar),
        _buildCard(loc.newPieChart, Colors.indigo, ChartType.pie),
      ],
    );
  }

  Widget _buildCard(
    String title,
    MaterialColor color,
    ChartType type,
  ) {
    final selected = type == this.type;
    final borderRadius = BorderRadius.circular(4);
    return Card(
      margin: const EdgeInsets.all(6),
      color: color.withOpacity(selected ? 1 : 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: selected ? BorderSide(color: Colors.black) : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => onChanged(type),
        borderRadius: borderRadius,
        splashColor: color.shade200,
        hoverColor: color.shade50,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: AbsorbPointer(
            child: Column(
              children: [
                if (type == ChartType.pie)
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: buildPieChart(),
                    ),
                  )
                else if (type == ChartType.line)
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(showTitles: false),
                          bottomTitles: SideTitles(showTitles: false),
                        ),
                        minX: 0,
                        maxX: 14,
                        maxY: 4,
                        minY: 0,
                        lineBarsData: linesBarData1(),
                      ),
                    ),
                  )
                else if (type == ChartType.bar)
                  Expanded(child: buildBarChart()),
                SizedBox(height: 3),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPieChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sections: List.generate(
          4,
          (i) {
            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: const Color(0xff0293ee),
                  value: 25,
                  title: '',
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff044d7c)),
                  titlePositionPercentageOffset: 0.55,
                );
              case 1:
                return PieChartSectionData(
                  color: Colors.pink,
                  value: 25,
                  title: '',
                  radius: 45,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff90672d)),
                  titlePositionPercentageOffset: 0.55,
                );
              case 2:
                return PieChartSectionData(
                  color: const Color(0xff845bef),
                  value: 25,
                  title: '',
                  radius: 40,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4c3788)),
                  titlePositionPercentageOffset: 0.6,
                );
              case 3:
                return PieChartSectionData(
                  color: const Color(0xff13d38e),
                  value: 25,
                  title: '',
                  radius: 50,
                  titleStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0c7f55)),
                  titlePositionPercentageOffset: 0.55,
                );
              default:
                return null;
            }
          },
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipBottomMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                  y: 8, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                  y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                  y: 14, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 15, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 13, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                  y: 10, colors: [Colors.lightBlueAccent, Colors.greenAccent])
            ],
            showingTooltipIndicators: [0],
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }
}
