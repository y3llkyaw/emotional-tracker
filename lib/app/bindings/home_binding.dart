import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<HomeController>(HomeController());

    Get.lazyPut<ProfilePageController>(() => ProfilePageController());
    Get.put<ProfilePageController>(ProfilePageController());

    Get.lazyPut<JournalController>(() => JournalController());
    Get.put<JournalController>(JournalController());
  }
}
