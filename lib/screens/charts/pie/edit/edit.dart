import 'package:chart_builder/widgets/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../../models/chart.dart';

import 'edit_info.dart';
import 'preview.dart';

class PieEdit extends StatefulWidget {
  const PieEdit({
    Key key,
    @required this.chart,
    @required this.onSaved,
    @required this.onDelete,
  }) : super(key: key);

  final Chart<PieChartData> chart;
  final Function(BuildContext, Chart<PieChartData>) onSaved;
  final Function onDelete;

  static Future<T> edit<T>(BuildContext context, PieEdit edit) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(builder: (_) => edit),
    );
  }

  @override
  _PieEditState createState() => _PieEditState();
}

class _PieEditState extends State<PieEdit> with TickerProviderStateMixin {
  Chart<PieChartData> chart;
  TextEditingController nameController;
  final key = GlobalKey<FormState>();

  final previewKey = GlobalKey<PreviewState>();

  TabController tabController;

  @override
  void initState() {
    chart = widget.chart.createCopy();
    nameController = TextEditingController(text: chart.name);
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pieCharts = context.watch<PieCharts>();
    final buttonDisabled = chart.isSameAs(pieCharts.getChart(chart.id));

    final editInfo = EditInfo(
      chart: chart,
      requestUpdate: (chart) {
        if (mounted) setState(() => this.chart = chart);
      },
      nameController: nameController,
      onDismiss: (context, section) {
        final index = chart.data.sections.indexOf(section);
        setState(() => chart.data.sections.removeAt(index));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('${section.title} was deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() => chart.data.sections.insert(index, section));
            },
          ),
        ));
      },
      onDelete: widget.onDelete,
    );

    final preview = Preview(
      key: previewKey,
      chart: chart,
      requestUpdate: (chart) {
        if (mounted) setState(() => this.chart = chart);
      },
    );

    return WillPopScope(
      onWillPop: () async {
        if (!buttonDisabled) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Are you sure you want to leave without saving your progress?',
              ),
              actions: [
                TextButton(
                  child: Text('Leave', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Save and Leave',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.teal,
                  onPressed: () {
                    widget.onSaved(context, chart);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          return false;
        }
        return true;
      },
      child: Form(
        key: key,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              controller: tabController,
              tabs: [Tab(text: 'Edit'), Tab(text: 'Preview')],
            ),
            actions: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: tabController.index == 0
                    ? IconButton(
                        key: ValueKey<int>(tabController.index),
                        icon: Icon(Icons.bookmark),
                        tooltip: 'Bookmark',
                        onPressed: () {},
                      )
                    : IconButton(
                        key: ValueKey<int>(tabController.index),
                        icon: Icon(Icons.camera_alt),
                        tooltip: 'Take screenshot',
                        onPressed: () async => ScreenshotDialog(
                          bytes: await previewKey.currentState.takeScreenshot(),
                          name: chart.name,
                        ).show(context),
                      ),
              ),
            ],
            // title: Text('Editing chart'),
            // bottom: TabBar(tabs: [Tab(text: 'Edit'), Tab(text: 'Preview')]),
          ),
          body: LayoutBuilder(builder: (context, consts) {
            final width = consts.biggest.width;
            if (width >= 500)
              return Row(children: [
                Expanded(child: editInfo),
                Expanded(child: preview),
              ]);
            return TabBarView(
              controller: tabController,
              children: [
                editInfo,
                preview,
              ],
            );
          }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: buttonDisabled
              ? null
              : FloatingActionButton.extended(
                  onPressed: buttonDisabled
                      ? null
                      : () => widget.onSaved(context, chart),
                  backgroundColor: buttonDisabled ? Colors.grey : null,
                  label: Text('Save'),
                ),
        ),
      ),
    );
  }
}
