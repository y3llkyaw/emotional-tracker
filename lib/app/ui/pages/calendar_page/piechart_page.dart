import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PiechartPage extends StatelessWidget {
  const PiechartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 3,
      width: Get.width,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
                color: Colors.red,
                showTitle: true,
                title: "super bad",
                value: 10),
            PieChartSectionData(
                color: Colors.orange,
                showTitle: true,
                title: "kinda bad",
                value: 40),
            PieChartSectionData(
                color: Colors.amber, showTitle: true, title: "Meh", value: 40),
            PieChartSectionData(
                color: Colors.lightGreen,
                showTitle: true,
                title: "Pretty Good",
                value: 20),
            PieChartSectionData(
                color: Colors.green,
                showTitle: true,
                title: "Awsome",
                value: 10),
          ],
        ),
      ),
    );
  }
}
