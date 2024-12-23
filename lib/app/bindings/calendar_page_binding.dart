import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:get/get.dart';

class CalendarPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalController>(() => JournalController());
    Get.put<JournalController>(JournalController());
  }
}
