import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chart.dart';

class ChooseName extends StatefulWidget {
  ChooseName({
    Key key,
    @required this.type,
  }) : super(key: key);

  final ChartType type;

  @override
  _ChooseNameState createState() => _ChooseNameState();
}

class _ChooseNameState extends State<ChooseName> {
  TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final barCharts = context.read<BarCharts>();
    final pieCharts = context.read<PieCharts>();
    final lineCharts = context.read<LineCharts>();
    if (controller == null)
      switch (widget.type) {
        case ChartType.bar:
          controller = TextEditingController(
            text: 'Bar Chart ${barCharts.charts.length + 1}',
          );
          break;
        case ChartType.pie:
          controller = TextEditingController(
            text: 'Pie Chart ${pieCharts.charts.length + 1}',
          );
          break;
        case ChartType.line:
          controller = TextEditingController(
            text: 'Line Chart ${lineCharts.charts.length + 1}',
          );
          break;
      }
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
                labelText: 'Chart name',
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: (text) {
                if (text.isEmpty) return 'This can NOT be empty';
                return null;
              },
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text('Create'),
                color: Colors.blue,
                onPressed: () {
                  if (!formKey.currentState.validate()) return;
                  switch (widget.type) {
                    case ChartType.bar:
                      barCharts.create(Chart(
                        name: controller.text,
                        data: BarChartData(),
                      ));
                      break;
                    case ChartType.pie:
                      pieCharts.create(createPieChart());
                      break;
                    case ChartType.line:
                      lineCharts.create(Chart(
                        name: controller.text,
                        data: LineChartData(),
                      ));
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
