import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../models/chart.dart';

class EditInfo extends StatelessWidget {
  const EditInfo({
    Key key,
    @required this.chart,
    @required this.requestUpdate,
  }) : super(key: key);

  final Chart<LineChartData> chart;
  final Function requestUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10) + EdgeInsets.only(bottom: 50),
      children: [
        TextFormField(
          initialValue: chart.name,
          decoration: InputDecoration(
            labelText: 'Name',
          ),
        ),
        // Divider(),
        Row(
          children: [
            Text('Datas', style: Theme.of(context).textTheme.headline6),
            SizedBox(width: 4),
            Expanded(child: Divider()),
            IconButton(
              tooltip: 'Add',
              icon: Icon(Icons.add),
              onPressed: () => createData(context),
            )
          ],
        ),
        if (chart.data.lineBarsData.isEmpty)
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'You have no data yet.\nPress on + to create a new one',
            ),
          )
        else
          Container(),
        Divider(),
      ],
    );
  }

  void createData(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Create data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

            ],
          ),
        );
      },
    );
  }
}
