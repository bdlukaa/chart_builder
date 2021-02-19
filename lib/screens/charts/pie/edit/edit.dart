import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:local_hero/local_hero.dart';

import '../../../../models/chart_database.dart';
import '../../../../models/chart.dart';
import '../../../../widgets/leave.dart';
import '../../../../langs/lang.dart';

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
  final Future Function(BuildContext, Chart<PieChartData>) onSaved;
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
    tabController.addListener(() {
      setState(() {});
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  void requestUpdate(Chart chart) {
    if (mounted) {
      setState(() => this.chart = chart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonDisabled = PieCharts.decodePieChart(
      chart.id,
      ChartDatabase.pieChartsBox.get(chart.id),
    ).isSameAs(chart);

    BaseLocalization loc = Localization.currentLocalization;

    final editInfo = EditInfo(
      chart: chart,
      requestUpdate: requestUpdate,
      nameController: nameController,
      onDismiss: (context, section) {
        final index = chart.data.sections.indexOf(section);
        setState(() => chart.data.sections.removeAt(index));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(loc.deleted(section.title)),
          action: SnackBarAction(
            label: loc.undo,
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
      requestUpdate: requestUpdate,
    );

    final scaffold = LayoutBuilder(builder: (context, consts) {
      final width = consts.biggest.width;
      bool isDoublePanel = width > 500;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Editing',
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.fade,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
            tooltip: loc.back,
            splashRadius: 20,
          ),
          actions: [
            if (!isDoublePanel)
              LocalHero(
                tag: 'tab',
                child: TextButton(
                  child: Text(
                    tabController.index == 0 ? loc.preview : loc.edit,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                  ),
                  onPressed: () {
                    if (tabController.index == 0) {
                      tabController.animateTo(1);
                    } else
                      tabController.animateTo(0);
                  },
                ),
              ),
            TextButton(
              child: Text(loc.save),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder()),
              ),
              onPressed: buttonDisabled
                  ? null
                  : () async {
                      await widget.onSaved(context, chart);
                      await Future.delayed(Duration(milliseconds: 500));
                      setState(() {});
                    },
            ),
          ],
          // title: Text('Editing chart'),
          // bottom: TabBar(tabs: [Tab(text: 'Edit'), Tab(text: 'Preview')]),
        ),
        body: Builder(builder: (context) {
          if (isDoublePanel)
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
      );
    });

    Widget child = WillPopScope(
      onWillPop: () async {
        if (!buttonDisabled) {
          showDialog(
            context: context,
            builder: (context) => SureWantToLeave(
              onLeave: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              onSaveAndLeave: () {
                widget.onSaved(context, chart);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          );
          return false;
        }
        return true;
      },
      child: scaffold,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          color: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: LocalHeroScope(
        duration: kTabScrollDuration,
        // curve: Curves.easeInOut,
        child: child,
      ),
    );
  }
}
