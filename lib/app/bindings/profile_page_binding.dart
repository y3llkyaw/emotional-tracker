import 'package:get/get.dart';

class ProfilePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePageBinding>(() => ProfilePageBinding());
    Get.put<ProfilePageBinding>(ProfilePageBinding());
  }
}
