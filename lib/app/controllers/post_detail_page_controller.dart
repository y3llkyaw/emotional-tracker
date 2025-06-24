import 'dart:developer';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:get/get.dart';

class PostDetailPageController extends GetxController {
  final likedProfileList = [].obs;
  var isLoading = false.obs;

  Future<void> getLikeProfileList(List<String> profileIds) async {
    isLoading.value = true; // Set loading state to true
    final ProfilePageController profilePageController = ProfilePageController();
    final OtherProfilePageController otherProfilePageController =
        OtherProfilePageController();

    likedProfileList.clear(); // Clear the list before fetching new profiles
    try {
      for (String pid in profileIds) {
        final profile = await profilePageController.getProfileByUid(pid);
        var friStatus = "not_friend"; // Default status
        await otherProfilePageController.checkFriendStatus(profile).then((v) {
          friStatus = otherProfilePageController.friendStatus.value!;
        });
        likedProfileList.add([
          profile,
          friStatus,
        ]);
      }
    } catch (e) {
      log("Error fetching liked profiles: $e");
    } finally {
      // Optionally, you can do something after fetching the profiles
      isLoading.value = false; // Set loading state to false
      // For example, you can update the UI or notify listeners
      log("Liked profiles fetched: ${likedProfileList.length}");
    }
  }
}
