import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendPiechart extends StatelessWidget {
  FriendPiechart({Key? key}) : super(key: key);
  final controller = Get.put(OtherProfilePageController());

  @override
  Widget build(BuildContext context) {
    TextStyle title = const TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.white70,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        const Text(
                          "Mood Count",
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Obx(
                          () {
                            return CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              child: Text(
                                controller.journals.length.toString(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Obx(
                      () {
                        double awsome = 0;
                        double pgood = 0;
                        double meh = 0;
                        double kindaBad = 0;
                        double superBad = 0;

                        for (var element in controller.journals) {
                          switch (element.value) {
                            case 0:
                              superBad++;
                              break;
                            case 1:
                              kindaBad++;
                              break;
                            case 2:
                              meh++;
                              break;
                            case 3:
                              pgood++;
                              break;
                            case 4:
                              awsome++;
                              break;
                            default:
                              break;
                          }
                        }
                        return PieChart(
                          PieChartData(
                            startDegreeOffset: 180,
                            centerSpaceColor: Colors.transparent,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            centerSpaceRadius: 65,
                            pieTouchData: PieTouchData(
                              touchCallback: (p0, p1) {},
                            ),
                            sections: [
                              PieChartSectionData(
                                color: Colors.red,
                                showTitle: true,
                                title: superBad.toInt().toString(),
                                value: superBad,
                                titleStyle: title,
                              ),
                              PieChartSectionData(
                                color: Colors.orange,
                                showTitle: true,
                                title: kindaBad.toInt().toString(),
                                value: kindaBad,
                                titleStyle: title,
                              ),
                              PieChartSectionData(
                                color: Colors.grey,
                                showTitle: true,
                                title: meh.toInt().toString(),
                                value: meh,
                                titleStyle: title,
                              ),
                              PieChartSectionData(
                                color: Colors.lightGreen,
                                showTitle: true,
                                title: pgood.toInt().toString(),
                                value: pgood,
                                titleStyle: title,
                              ),
                              PieChartSectionData(
                                color: Colors.green,
                                showTitle: true,
                                title: awsome.toInt().toString(),
                                value: awsome,
                                titleStyle: title,
                              ),
                            ],
                          ),
                        );
                      },
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
                  _labelWidget(Colors.grey, "Meh"),
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
          radius: 7,
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
