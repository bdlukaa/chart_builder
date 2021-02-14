import 'package:flutter/material.dart';

import '../../../../models/chart.dart';

import 'edit_info.dart';
import 'preview.dart';

class LineEdit extends StatefulWidget {
  const LineEdit({
    Key key,
    @required this.chart,
    @required this.onSaved,
  }) : super(key: key);

  final Chart chart;
  final Function(BuildContext, Chart) onSaved;

  static Future<T> edit<T>(BuildContext context, LineEdit edit) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => edit),
    );
  }

  @override
  _LineEditState createState() => _LineEditState();
}

class _LineEditState extends State<LineEdit> {
  Chart chart;

  @override
  void initState() {
    chart = widget.chart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editing chart'),
          bottom: TabBar(tabs: [Tab(text: 'Edit'), Tab(text: 'Preview')]),
        ),
        body: TabBarView(
          children: [
            EditInfo(
              chart: widget.chart,
              requestUpdate: (chart) => setState(() => this.chart = chart),
            ),
            Preview(chart: widget.chart),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.onSaved?.call(context, widget.chart);
          },
          label: Text('Save'),
        ),
      ),
    );
  }
}
