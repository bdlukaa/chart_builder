import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/root.dart';

import 'models/chart.dart';
import 'models/chart_database.dart';
import 'models/settings.dart';

import 'utils/theme.dart';

void main() async {
  await Hive.initFlutter();
  await Settings.open();
  await ChartDatabase.open();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),
        // Chart providers
        ChangeNotifierProvider<LineCharts>(create: (_) => LineCharts()),
        ChangeNotifierProvider<BarCharts>(create: (_) => BarCharts()),
        ChangeNotifierProvider<PieCharts>(create: (_) => PieCharts()),
      ],
      builder: (context, child) {
        final theme = context.watch<AppTheme>();
        return MaterialApp(
          title: 'Chart Builder',
          themeMode: theme.mode,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: Root(),
        );
      },
    );
  }
}
