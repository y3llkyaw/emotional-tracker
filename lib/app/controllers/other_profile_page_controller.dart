import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:get/get.dart';

class OtherProfilePageController extends GetxController {
  final _friendsController = Get.find<FriendsController>();
  final friendStatus = Rx<String?>(null);
  final isLoading = false.obs;
  final journals = [].obs;

  Future<void> fetchJournals(String uid) async {
    log("fetch-journal", name: "journal-controller");
    try {
      final journalCollection = await FirebaseFirestore.instance
          .collection("profile")
          .doc(uid)
          .collection("journals")
          .get();

      journals.value = journalCollection.docs
          .map((journal) => Journal.fromDocument(journal.data()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    update();
  }

  Future<void> checkFriendStatus(Profile profile) async {
    try {
      friendStatus.value = await _friendsController.checkFriendStatus(profile);
    } catch (e) {
      print('Error checking friend status: $e');
    }
  }

  Stream<String> friendStatusStream(String uid) {
    _friendsController.friendStatusStream(uid).listen((data) {
      log(data, name: "fri-status-stream");
      friendStatus.value = data;
    });
    return _friendsController.friendStatusStream(uid);
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
