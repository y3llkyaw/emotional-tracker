import 'package:emotion_tracker/app/controllers/local_auth_controller.dart';
import 'package:get/get.dart';

class ProfileUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalAuthController>(() => LocalAuthController());
    Get.put<LocalAuthController>(LocalAuthController());
  }
}
