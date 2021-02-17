import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'charts/line/home.dart';
import 'charts/bar/home.dart';
import 'charts/pie/home.dart';
// import 'scatter/home.dart';
import 'new_chart/home.dart';

import 'settings/home.dart';

import '../langs/lang.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    BaseLocalization loc = Localization.currentLocalization;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        leading: IconButton(
          tooltip: loc.settings,
          icon: Icon(Icons.settings),
          onPressed: () => showSettings(context),
          splashRadius: 26,
        ),
        actions: [
          TextButton(
            child: Text(loc.newButton),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.all(
                Theme.of(context).splashColor,
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder()),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => DraggableScrollableSheet(
                  builder: (_, controller) => NewChartHome(
                    controller: controller,
                    initialIndex: _index,
                  ),
                  expand: false,
                  maxChildSize: 0.9,
                  initialChildSize: 0.9,
                ),
              );
            },
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) =>
            FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: [
          LineHome(),
          BarHome(),
          PieHome(),
          SizedBox(),
          // ScatterHome(),
        ][_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: loc.newLineChart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: loc.newBarChart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: loc.newPieChart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scatter_plot),
            label: loc.newScatterChart,
          ),
        ],
      ),
    );
  }
}
