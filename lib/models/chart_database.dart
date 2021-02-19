import 'package:hive/hive.dart';

class ChartDatabase {

  static Future<void> open() async {
    await Hive.openBox<Map>('lineCharts');
    await Hive.openBox<Map>('barCharts');
    await Hive.openBox<Map>('pieCharts');
  }

  static Box<Map> get lineChartsBox => Hive.box<Map>('lineCharts');
  static Box<Map> get barChartsBox => Hive.box<Map>('barCharts');
  static Box<Map> get pieChartsBox => Hive.box<Map>('pieCharts');

}