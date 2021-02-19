import 'package:chart_builder/models/chart_database.dart';
import 'package:flutter/material.dart';

import '../../chart_homes.dart';
import '../../../models/chart.dart';
import '../../../utils/toast/toast.dart';
import '../../../langs/lang.dart';

import 'edit/edit.dart';

class PieHome extends StatefulWidget {
  const PieHome({Key key}) : super(key: key);

  @override
  _PieHomeState createState() => _PieHomeState();
}

class _PieHomeState extends State<PieHome> {
  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    final box = ChartDatabase.pieChartsBox;
    final Function(Chart) deleteChart = (chart) {
      PieCharts.delete(chart);
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(loc.deleted(chart.name)),
        action: SnackBarAction(
          label: loc.undo,
          onPressed: () => PieCharts.create(chart),
        ),
      ));
    };
    return ChartHome(
      type: ChartType.pie,
      box: box,
      boxEmptyMessage: loc.noPieChartsCreated,
      deleteChart: deleteChart,
      editChart: (chart) {
        PieEdit.edit(
          context,
          PieEdit(
            chart: chart,
            onSaved: (context, chart) async {
              await PieCharts.update(chart);
              showTextToast(
                context: context,
                text: loc.saved(chart.name),
              );
            },
            onDelete: () => deleteChart(chart),
          ),
        );
      },
    );
  }
}
