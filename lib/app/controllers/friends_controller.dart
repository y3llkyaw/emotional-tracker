import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/data/services/friends_service.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  RxBool isLoading = false.obs;
  var searchResults = [].obs;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  final _friendService = FriendService();
  final notificationController = NotiController();
  final profilePageController = ProfilePageController();
  final onlineController = OnlineController();
  final _ns = NotificationService();

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

  Future<String> checkFriendStatus(Profile profile) async {
    // check friend status
    final status = await _friendService.checkFriendStatus(profile.uid);
    return status;
  }

  Future<void> confirmFriendRequest(Profile profile) async {
    isLoading.value = true;
    await _friendService.confirmFriendRequest(profile).then((value) async {
      await notificationController.getNotification();
    });
    isLoading.value = false;
  }

  Future<void> unfriend(Profile profile) async {
    await _friendService.deleteFriends(_cuid, profile.uid);
    await _friendService.deleteFriends(profile.uid, _cuid);

    await _ns.deleteNoti(profile.uid, _cuid);
    await _ns.deleteNoti(_cuid, profile.uid);
  }

  Future<void> getFriends() async {
    final result = await _friendService.getFriends();
    friends.value = result;
    friends.map((f) async {
      onlineController.getFriendsOnlineStatus(f.uid);
    });
  }
}
