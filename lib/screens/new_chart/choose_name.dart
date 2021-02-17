import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chart.dart';
import '../../langs/lang.dart';

class ChooseName<T extends ChartNotifier> extends StatefulWidget {
  ChooseName({
    Key key,
    @required this.type,
  }) : super(key: key);

  final ChartType type;

  @override
  _ChooseNameState createState() => _ChooseNameState<T>();
}

class _ChooseNameState<T extends ChartNotifier> extends State<ChooseName> {
  TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final charts = context.read<T>();
    BaseLocalization loc = Localization.currentLocalization;

    controller = TextEditingController(
      text: loc.chartGeneratedName(widget.type, charts.charts.length + 1),
    );

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: loc.chartName,
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (text) {
                if (text.isEmpty) return loc.canNotBeEmpty;
                return null;
              },
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(loc.create),
                color: Colors.blue,
                onPressed: () {
                  if (!formKey.currentState.validate()) return;
                  switch (widget.type) {
                    case ChartType.bar:
                      charts.create(Chart(
                        name: controller.text,
                        data: BarChartData(),
                      ));
                      break;
                    case ChartType.pie:
                      charts.create(createPieChart());
                      break;
                    case ChartType.line:
                      charts.create(Chart(
                        name: controller.text,
                        data: LineChartData(),
                      ));
                      break;
                    default:
                      break;
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Chart<PieChartData> createPieChart() {
    final colors = [
      Colors.redAccent,
      Colors.pink,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal.shade800,
      Colors.amber,
      Colors.brown,
    ];
    colors.shuffle();
    return Chart(
      name: controller.text,
      data: PieChartData(
        centerSpaceRadius: 40,
        sections: List.generate(4, (index) {
          return PieChartSectionData(
            title: 'Section ${index + 1}',
            color: colors[index],
            radius: 100,
          );
        }),
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
