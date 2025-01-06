import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:get/get.dart';

class FriendsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(() => FriendsController());
    Get.put<FriendsController>(FriendsController());
  }
}
