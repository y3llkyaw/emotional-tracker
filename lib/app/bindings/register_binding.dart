import 'package:emotion_tracker/app/controllers/register_email_controller.dart';
import 'package:get/get.dart';

class RegisterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterEmailController>(() => RegisterEmailController());
    Get.put<RegisterEmailController>(RegisterEmailController());
  }
}
