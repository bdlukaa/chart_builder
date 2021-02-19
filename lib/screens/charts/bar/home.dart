import 'package:chart_builder/models/chart_database.dart';
import 'package:flutter/material.dart';

import '../../chart_homes.dart';
import '../../../models/chart.dart';

class BarHome extends StatelessWidget {
  const BarHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChartHome(
      type: ChartType.bar,
      box: ChartDatabase.barChartsBox,
      deleteChart: (chart) {},
      editChart: (chart) {
        // BarEdit.edit(context, BarEdit(
        //   chart: chart,
        //   onSaved: (context, chart) {
        //     context.read<BarCharts>().update(chart);
        //     showTextToast(
        //       context: context,
        //       text: '${chart.name ?? 'Chart'} saved',
        //     );
        //   },
        // ));
      },
    );
  }
}
