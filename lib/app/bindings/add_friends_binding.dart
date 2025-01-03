import 'package:emotion_tracker/app/controllers/add_friends_controller.dart';
import 'package:get/get.dart';

class AddFriendsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFriendsController>(() => AddFriendsController());
    Get.put<AddFriendsController>(AddFriendsController());
  }
}
