import 'package:chart_builder/models/chart_database.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'choose_type.dart';
import 'choose_name.dart';
import '../../models/chart.dart';
import '../../langs/lang.dart';

class NewChartHome extends StatefulWidget {
  const NewChartHome({
    Key key,
    this.controller,
    this.initialIndex = 0,
  }) : super(key: key);

  final int initialIndex;

  final ScrollController controller;

  @override
  _NewChartHomeState createState() => _NewChartHomeState();
}

class _NewChartHomeState extends State<NewChartHome> {
  int _index = 0;
  ChartType type;

  @override
  void initState() {
    super.initState();
    switch (widget.initialIndex) {
      case 0:
        type = ChartType.line;
        break;
      case 1:
        type = ChartType.bar;
        break;
      case 2:
        type = ChartType.pie;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      children: [
        buildTop(context),
        Divider(),
        PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: [
            ChooseChartType(
              type: type,
              onChanged: (type) => setState(() => this.type = type),
            ),
            if (type == ChartType.pie)
              ChooseName(type: type, box: ChartDatabase.pieChartsBox)
            else if (type == ChartType.bar)
              ChooseName(type: type, box: ChartDatabase.barChartsBox)
            else if (type == ChartType.line)
              ChooseName(type: type, box: ChartDatabase.lineChartsBox),
          ][_index],
        ),
      ],
    );
  }

  Widget buildTop(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return ListTile(
      leading: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: _index == 0
            ? IconButton(
                icon: Icon(Icons.add, color: Colors.transparent),
                onPressed: null,
              )
            : IconButton(
                icon: Icon(Icons.navigate_before),
                onPressed: () => setState(() => _index--),
              ),
      ),
      title: Text(
        loc.newChart,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: _index == 1
            ? IconButton(
                icon: Icon(Icons.add, color: Colors.transparent),
                onPressed: null,
              )
            : IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: () => setState(() => _index++),
              ),
      ),
    );
  }
}
