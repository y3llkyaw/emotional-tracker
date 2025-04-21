import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/mood_staticstics_page_controller.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoodStaticsticsPage extends StatefulWidget {
  const MoodStaticsticsPage({Key? key}) : super(key: key);

  @override
  State<MoodStaticsticsPage> createState() => _MoodStaticsticsPageState();
}

class _MoodStaticsticsPageState extends State<MoodStaticsticsPage> {
  final MoodStaticsticsPageController moodStaticsticsPageController =
      Get.put(MoodStaticsticsPageController());

  final journalController = Get.put(JournalController());
  final txtStyle = TextStyle(color: Get.theme.colorScheme.onSurface);
  var journals = [];
  var filteredJournal = [];
  int dropDown = 0;
  TextStyle title = const TextStyle(
    fontWeight: FontWeight.w400,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    journals = moodStaticsticsPageController.filteredJournal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Analytics"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                              SizedBox(height: Get.height * 0.01),
                              Obx(() {
                                return CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                  child: Text(
                                    moodStaticsticsPageController
                                        .filteredJournal.length
                                        .toString(),
                                    style: TextStyle(
                                      color: Get.theme.hintColor,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          Obx(() {
                            double awsome = 0;
                            double pgood = 0;
                            double meh = 0;
                            double kindaBad = 0;
                            double superBad = 0;

                            for (var element in moodStaticsticsPageController
                                .filteredJournal) {
                              switch (element.value) {
                                case null:
                                  break;
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
                              }
                            }

                            return PieChart(
                              PieChartData(
                                startDegreeOffset: 180,
                                centerSpaceColor: Colors.transparent,
                                borderData: FlBorderData(show: false),
                                centerSpaceRadius: 65,
                                pieTouchData: PieTouchData(
                                  touchCallback: (p0, p1) {},
                                ),
                                sections: [
                                  PieChartSectionData(
                                    color: Colors.red,
                                    title: superBad.toInt().toString(),
                                    value: superBad,
                                    titleStyle: title,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.orange,
                                    title: kindaBad.toInt().toString(),
                                    value: kindaBad,
                                    titleStyle: title,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.grey,
                                    title: meh.toInt().toString(),
                                    value: meh,
                                    titleStyle: title,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.lightGreen,
                                    title: pgood.toInt().toString(),
                                    value: pgood,
                                    titleStyle: title,
                                  ),
                                  PieChartSectionData(
                                    color: Colors.green,
                                    title: awsome.toInt().toString(),
                                    value: awsome,
                                    titleStyle: title,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // int? selectedValue;

                        SizedBox(
                          width: Get.width * 0.3,
                          child: DropdownButtonFormField<int>(
                            borderRadius: BorderRadius.circular(20),
                            value: 1,
                            decoration: InputDecoration(
                              labelText: 'Filter',
                              labelStyle: TextStyle(
                                color: Get.theme.colorScheme.onSurface,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 1, child: Text('All Time')),
                              DropdownMenuItem(value: 2, child: Text('7d ago')),
                              DropdownMenuItem(
                                  value: 3, child: Text('30d ago')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                moodStaticsticsPageController.filterMood(value);
                              }
                            },
                          ),
                        ),

                        SizedBox(height: Get.height * 0.02),
                        _labelWidget(Colors.red, "Super Bad"),
                        _labelWidget(Colors.orange, "Kinda Bad"),
                        _labelWidget(Colors.grey, "Meh"),
                        _labelWidget(Colors.lightGreen, "Pretty Good"),
                        _labelWidget(Colors.green, "Awesome"),
                        SizedBox(height: Get.height * 0.02),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
                // SizedBox(height: Get.height * 0.05),
                SizedBox(
                  height: Get.height * 0.4,
                  width: Get.width * 0.9,
                  child: Obx(() {
                    // final journals = journalController.journals;
                    final List<FlSpot> spots = [];
                    final List<DateTime> dates = [];

                    for (int i = 0; i < journals.length; i++) {
                      final entry = journals[i];
                      spots.add(FlSpot(i.toDouble(), entry.value.toDouble()));
                      dates.add(entry.date);
                    }
                    if (journals.length < 3) {
                      return Center(
                        child: Container(
                          // margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)),
                          height: Get.height * 0.2,
                          width: Get.width * 0.9,
                          child: Center(
                            child: Text(
                              "Line chart need to have at least 3 moods.\n ${journalController.journals.length} of 3",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          // height: Get.height * 0.4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          width: journalController.journals.length *
                                  (Get.width * 0.1) +
                              200, // Adjust based on how much scroll you want
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    interval: 1,
                                    reservedSize: 100,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        valueToString(value.toInt()),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: valueToColor(value.toInt()),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index < 0 || index >= dates.length) {
                                        return const SizedBox.shrink();
                                      }
                                      final date = dates[index];
                                      final formatted =
                                          DateFormat('dd MMM').format(date);
                                      return Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          formatted,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: false,
                                  // color: Colors.blue,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 5,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.2),
                                  ),
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipRoundedRadius: 10,
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipItems:
                                      (List<LineBarSpot> touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      final formattedDate =
                                          DateFormat('dd MMM, yyyy')
                                              .format(dates[spot.x.toInt()]);
                                      // final mood = valueToString(moodEntry.value);

                                      return LineTooltipItem(
                                        '$formattedDate\nMood: ${valueToString(spot.y.toInt())} ',
                                        const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          )
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
        SizedBox(width: Get.width * 0.03),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
      ],
    ),
  );
}
