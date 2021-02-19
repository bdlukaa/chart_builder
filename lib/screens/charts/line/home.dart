import 'package:chart_builder/models/chart_database.dart';
import 'package:chart_builder/utils/toast/toast.dart';
import 'package:flutter/material.dart';

import '../../../models/chart.dart';
import '../../chart_homes.dart';
import 'edit/edit.dart';

class LineHome extends StatelessWidget {
  const LineHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChartHome(
      type: ChartType.line,
      box: ChartDatabase.lineChartsBox,
      deleteChart: (chart) {},
      editChart: (chart) {
        LineEdit.edit(
            context,
            LineEdit(
              chart: chart,
              onSaved: (context, chart) {
                // context.read<LineCharts>().update(chart);
                showTextToast(
                  context: context,
                  text: '${chart.name ?? 'Chart'} saved',
                );
              },
            ));
      },
    );
  }
}
