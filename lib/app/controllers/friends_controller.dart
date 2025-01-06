import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/data/services/friends_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  RxBool isLoading = false.obs;
  var searchResults = [].obs;
  final cuid = FirebaseAuth.instance.currentUser!.uid;
  final _friendService = FriendService();
  final notificationController = NotiController();
  final profilePageController = ProfilePageController();

  var friends = [].obs;

  @override
  onInit() {
    getFriends();
    super.onInit();
  }

  Future<void> searchFriendsWithName(String query) async {
    searchResults.value = await _friendService.searchFriendsWithName(query);
  }

  Future<void> addFriend(Profile profile) async {
    // add friend
    await _friendService.addFriend(profile);
  }

  Future<void> removeFriendRequest(Profile profile) async {
    // add friend
    await _friendService.removeFriendRequest(profile);
  }

  Future<String?> checkFriendStatus(Profile profile) async {
    // check friend status
    final status = await _friendService.checkFriendStatus(profile);
    return status;
  }

  Future<void> confirmFriendRequest(Profile profile) async {
    // check friend status
    await _friendService.confirmFriendRequest(profile).then((value) async {
      await notificationController.getNotification();
    });
  }

  Future<void> getFriends() async {
    isLoading.value = true;
    final result = await _friendService.getFriends();
    friends.value = result;
    isLoading.value = false;
  }
}
