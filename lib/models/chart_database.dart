import 'package:hive/hive.dart';

class ChartDatabase {

  static Future<void> open() async {
    await Hive.openLazyBox('lineCharts');
    await Hive.openLazyBox('barCharts');
    await Hive.openLazyBox('pieCharts');
  }

  static LazyBox get lineChartsBox => Hive.lazyBox('lineCharts');
  static LazyBox get barChartsBox => Hive.lazyBox('barCharts');
  static LazyBox get pieChartsBox => Hive.lazyBox('pieCharts');

}