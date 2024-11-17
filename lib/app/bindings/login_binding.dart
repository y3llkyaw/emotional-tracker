import 'package:emotion_tracker/app/controllers/auth_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.put<AuthController>(AuthController());
  }
}
