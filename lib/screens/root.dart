import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'charts/line/home.dart';
import 'charts/bar/home.dart';
import 'charts/pie/home.dart';
// import 'scatter/home.dart';
import 'new_chart/home.dart';

import 'settings/home.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Builder'),
        leading: IconButton(
          tooltip: 'Settings',
          icon: Icon(Icons.settings),
          onPressed: () => showSettings(context),
        ),
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
          // ScatterHome(),
        ][_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Line',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Bar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Pie',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.scatter_plot),
          //   label: 'Scatter',
          // ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
        icon: Icon(Icons.add),
        label: Text('New'),
      ),
    );
  }
}
