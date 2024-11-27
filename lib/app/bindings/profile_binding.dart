import 'package:emotion_tracker/app/controllers/profile_setup_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetupController>(() => ProfileSetupController());
    Get.put<ProfileSetupController>(ProfileSetupController());
  }
}
