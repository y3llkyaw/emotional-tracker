import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:get/get.dart';

class OtherProfilePageController extends GetxController {
  final _friendsController = Get.find<FriendsController>();
  final friendStatus = Rx<String?>(null);
  final isLoading = false.obs;

  Future<void> checkFriendStatus(Profile profile) async {
    try {
      friendStatus.value = await _friendsController.checkFriendStatus(profile);
    } catch (e) {
      print('Error checking friend status: $e');
    }
  }

  Future<void> handleFriendAction(
    Profile profile,
    Future<void> Function() action,
  ) async {
    try {
      isLoading.value = true;
      await action();
      await checkFriendStatus(profile);
    } catch (e) {
      print('Error handling friend action: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFriend(Profile profile) async {
    await handleFriendAction(
      profile,
      () => _friendsController.addFriend(profile),
    );
  }

  Future<void> removeFriendRequest(Profile profile) async {
    await handleFriendAction(
      profile,
      () => _friendsController.removeFriendRequest(profile),
    );
  }

  Future<void> confirmRequest(Profile profile) async {
    await handleFriendAction(
      profile,
      () => _friendsController.confirmFriendRequest(profile),
    );
  }
}
