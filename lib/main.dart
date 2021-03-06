import 'package:flutter/material.dart';
import 'package:get_localization/get_localization.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/root.dart';

import 'models/chart_database.dart';
import 'models/settings.dart';

import 'utils/theme.dart';

import 'langs/lang.dart';

void main() async {
  await Hive.initFlutter();
  await Settings.open();
  await ChartDatabase.open();
  Localization.localizations
    ..add(EnglishLocalization())
    ..add(PortugueseLocalization());
  Localization.init();
  Localization.currentLocalization = Settings.currentLanguage;
  Localization.onLocaleChanged.listen((e) => Settings.currentLanguage = e);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),
      ],
      builder: (context, child) => StreamBuilder(
        stream: Localization.onLocaleChanged,
        builder: (context, _) {
          final theme = context.watch<AppTheme>();
          BaseLocalization localization = Localization.currentLocalization;
          return MaterialApp(
            supportedLocales: Localization.localizations.toLocaleList(),
            title: localization.appTitle,
            themeMode: theme.mode,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            debugShowCheckedModeBanner: false,
            home: Root(),
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: NoGlowBehavior(),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(context, child, axisDirection) {
    return child;
  }

  ScrollPhysics getScrollPhysics(BuildContext context) {
    return BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());
  }
}
