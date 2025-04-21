import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:get/get.dart';

class MoodStaticsticsPageController extends GetxController {
  var filteredJournal = [].obs;
  final JournalController journalController = Get.put(JournalController());

  @override
  void onInit() async {
    super.onInit();
    // await getCurrentUserProfile();
    filteredJournal.value = journalController.journals;
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
        break;
      case 2:
        filteredJournal.value = journalController.journals
            .where((e) => isWithinLast7Days(e.date))
            .toList();
        break;
      case 3:
        filteredJournal.value = journalController.journals
            .where((e) => isWithinLast30Days(e.date))
            .toList();
        break;
    }
    print(filteredJournal);
    print(journalController.journals);
  }
}
