import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class OnlineController extends GetxController {
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  var lastSeem = DateTime.now().obs;
  var isOnline = false.obs;
  var friendsOnlineStatus = {}.obs;

  @override
  onInit() {
    super.onInit();
    setOnlineStatus();
  }

  // Update user's online status
  Future<void> updateOnlineStatus() async {
    final onlineRef = FirebaseDatabase.instance.ref("isOnline/$_cuid");
    await onlineRef.set({
      "isOnline": true,
      "uid": _cuid,
      "lastSeem": DateTime.now().toIso8601String(),
    });
  }

  void setOnlineStatus() {
    final onlineRef = FirebaseDatabase.instance.ref("isOnline/$_cuid");
    onlineRef.set({
      "isOnline": true,
      "uid": _cuid,
      "lastSeem": DateTime.now().toIso8601String(),
    });
    onlineRef.onDisconnect().set({
      "isOnline": false,
      "uid": _cuid,
      "lastSeem": DateTime.now().toIso8601String(),
    });
  }

  // Get user's online status
  Future<void> getFriendOnlineStatus(String uid) async {
    final ref = FirebaseDatabase.instance.ref("isOnline/$uid");
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      isOnline.value = data["isOnline"];
      lastSeem.value = DateTime.parse(data["lastSeem"]);
    }
  }

  Future<int> getOnlineUserCount() async {
    final ref = FirebaseDatabase.instance.ref("isOnline");
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      // Count users where "isOnline" is true
      int onlineCount = data.values
          .where((user) => user is Map && user["isOnline"] == true)
          .length;
      // Optionally, you can store or use onlineCount as needed
      log('Online user count: $onlineCount');
      return onlineCount;
    }
    return 0; // Return 0 if no users are online
  }

  // Get all friends online status (for a list of uids)
  Future<void> getFriendsOnlineStatus(List<String> uids) async {
    try {
      for (final uid in uids) {
        final ref = FirebaseDatabase.instance.ref("isOnline/$uid");
        final snapshot = await ref.get();
        if (snapshot.exists && snapshot.value != null) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          friendsOnlineStatus[uid] = DateTime.parse(data["lastSeem"]);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
