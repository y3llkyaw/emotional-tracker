import 'dart:math';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:get/get.dart';

class MoodStaticsticsPageController extends GetxController {
  var filteredJournal = [].obs;
  var standardDeviation = 0.0.obs;
  final JournalController journalController = Get.put(JournalController());

  @override
  void onInit() async {
    super.onInit();
    // await getCurrentUserProfile();
    filteredJournal.value = journalController.journals;
    getStandardDeviation();
  }

  bool isWithinLast7Days(DateTime date) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return date.isAfter(sevenDaysAgo) &&
        date.isBefore(now.add(const Duration(days: 1)));
  }

  bool isWithinLast30Days(DateTime date) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    return date.isAfter(thirtyDaysAgo) &&
        date.isBefore(now.add(const Duration(days: 1)));
  }

  void filterMood(int value) {
    switch (value) {
      case 1:
        filteredJournal.value = journalController.journals;
        getStandardDeviation();
        break;
      case 2:
        filteredJournal.value = journalController.journals
            .where((e) => isWithinLast7Days(e.date))
            .toList();
        getStandardDeviation();
        break;
      case 3:
        filteredJournal.value = journalController.journals
            .where((e) => isWithinLast30Days(e.date))
            .toList();
        getStandardDeviation();
        break;
    }
  }

  void getStandardDeviation() {
    final n = filteredJournal.length.toDouble();
    if (n <= 1) {
      standardDeviation.value = 0.0;
      return; // Prevent divide by zero for (n - 1)
    }

    final values = filteredJournal.map((j) => j.value.toDouble()).toList();
    final mean = values.reduce((a, b) => a + b) / n;

    final squaredDiffs = values.map((v) => pow(v - mean, 2)).toList();
    final sumSquaredDiffs = squaredDiffs.reduce((a, b) => a + b);

    standardDeviation.value = sqrt(sumSquaredDiffs / (n - 1));

    // Optional: Using the `stats` package if desired

    List<double> a = [];
    for (var value in values) {
      a.add(value);
    }
    // final stats = Stats.fromData(a);
    // print(
    //     "Manual: ${standardDeviation.value}, Package: ${stats.standardDeviation}");
  }

  String getStdDevLevel(double stdDev) {
    if (stdDev < 0.8) return 'Low';
    if (stdDev < 1.8) return 'Moderated';
    return 'High';
  }

  
}
