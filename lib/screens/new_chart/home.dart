import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'choose_type.dart';
import 'choose_name.dart';
import '../../models/chart.dart';

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
        buildTop(),
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
            ChooseName(type: type),
            // ScatterHome(),
          ][_index],
        ),
      ],
    );
  }

  Widget buildTop() {
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
        'New chart',
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
