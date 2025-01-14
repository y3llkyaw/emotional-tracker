import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PiechartPage extends StatelessWidget {
  PiechartPage({Key? key}) : super(key: key);
  final journalController = Get.put(JournalController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Text(
                  "Your Mood Analytics",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.04,
                  ),
                ),
              ),
              const Spacer(),
              // SizedBox(
              //   width: Get.width / 3,
              //   child: DropdownButton(
              //     underline: Container(),
              //     selectedItemBuilder: (context) {
              //       return ["over all", "this week", "this month"]
              //           .map((e) => Text(e))
              //           .toList();
              //     },
              //     value: "over all",
              //     items: const [
              //       DropdownMenuItem(
              //         value: "over all",
              //         child: Text("over all"),
              //       ),
              //       DropdownMenuItem(
              //         value: "this week",
              //         child: Text("this week"),
              //       ),
              //       DropdownMenuItem(
              //         value: "this month",
              //         child: Text("this month"),
              //       ),
              //     ],
              //     onChanged: (value) {},
              //   ),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: Get.height / 4,
                width: Get.width / 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mood Count",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Obx(
                          () {
                            return CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              child: Text(
                                journalController.journals.length.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    PieChart(
                      PieChartData(
                        startDegreeOffset: 180,
                        centerSpaceColor: Colors.transparent,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        centerSpaceRadius: 70,
                        pieTouchData: PieTouchData(
                          touchCallback: (p0, p1) {},
                        ),
                        sections: [
                          PieChartSectionData(
                              color: Colors.red,
                              showTitle: false,
                              title: "super bad",
                              value: 10),
                          PieChartSectionData(
                              color: Colors.orange,
                              showTitle: false,
                              title: "kinda bad",
                              value: 40),
                          PieChartSectionData(
                              color: Colors.amber,
                              showTitle: false,
                              title: "Meh",
                              value: 40),
                          PieChartSectionData(
                              color: Colors.lightGreen,
                              showTitle: false,
                              title: "Pretty Good",
                              value: 20),
                          PieChartSectionData(
                              color: Colors.green,
                              showTitle: false,
                              title: "Awsome",
                              value: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelWidget(Colors.red, "Super Bad"),
                  _labelWidget(Colors.orange, "Kinda Bad"),
                  _labelWidget(Colors.amber, "Meh"),
                  _labelWidget(Colors.lightGreen, "Pretty Good"),
                  _labelWidget(Colors.green, "Awsome"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget _labelWidget(Color color, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: Get.width * 0.002,
      vertical: Get.height * 0.004,
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color,
        ),
        SizedBox(
          width: Get.width * 0.03,
        ),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
