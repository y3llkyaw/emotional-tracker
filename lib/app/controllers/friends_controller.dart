import 'dart:developer';

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
    try {
      await _friendService.createFriendsData(_cuid, profile.uid, "requested");
      await _friendService.createFriendsData(profile.uid, _cuid, "pending");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeFriendRequest(Profile profile) async {
    await _friendService.deleteFriendsData(profile.uid, _cuid);
    await _friendService.deleteFriendsData(_cuid, profile.uid);
  }

  Future<void> acceptFriendRequest(Profile profile) async {
    await _friendService.createFriendsData(_cuid, profile.uid, "friend");
    await _friendService.createFriendsData(profile.uid, _cuid, "friend");
  }

  Future<String> checkFriendStatus(Profile profile) async {
    // check friend status
    final status = await _friendService.checkFriendStatus(profile.uid);

    return status;
  }

  Stream<String> friendStatusStream(String uid) {
    return _friendService.friendStatusStream(uid);
  }

  Future<void> confirmFriendRequest(Profile profile) async {
    isLoading.value = true;
    // await _friendService.confirmFriendRequest(profile).then((value) async {
    //   await notificationController.getNotification();
    // });
    isLoading.value = false;
  }

  Future<void> unfriend(Profile profile) async {
    // await _friendService.deleteFriends(_cuid, profile.uid);
    // await _friendService.deleteFriends(profile.uid, _cuid);

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
