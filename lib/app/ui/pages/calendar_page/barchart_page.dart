import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarchartPage extends StatelessWidget {
  const BarchartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      barGroups: [],
    ));
  }
}
