import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../chart_homes.dart';
import '../../../models/chart.dart';
import '../../../utils/toast/toast.dart';
import '../../../langs/lang.dart';

import 'edit/edit.dart';

class PieHome extends StatelessWidget {
  const PieHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    final Function(Chart) deleteChart = (chart) {
      context.read<PieCharts>().delete(chart);
      Navigator.pop(context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('${chart.name} was deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => context.read<PieCharts>().create(chart),
        ),
      ));
    };
    return ChartHome<PieCharts>(
      boxName: 'pieCharts',
      boxEmptyMessage: loc.noPieChartsCreated,
      deleteChart: deleteChart,
      editChart: (chart) {
        PieEdit.edit(
          context,
          PieEdit(
            chart: chart,
            onSaved: (context, chart) {
              context.read<PieCharts>().update(chart);
              showTextToast(
                context: context,
                text: '${chart.name ?? 'Chart'} saved',
              );
            },
            onDelete: () => deleteChart(chart),
          ),
        );
      },
    );
  }
}
