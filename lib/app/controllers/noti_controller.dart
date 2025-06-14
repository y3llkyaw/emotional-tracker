import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotiController extends GetxController {
  final NotificationService ns = NotificationService();
  var notifications = const Stream<List<Map<String, dynamic>>>.empty().obs;

  @override
  onInit() {
    streamUnreadNoti();
    getAllNotification();
    super.onInit();
  }

  Future<void> getNotification() async {
    notifications.value = streamUnreadNoti();
  }

  Future<void> getAllNotification() async {
    notifications.value = streamAllNoti();
  }

  Future<void> likePost(Post post) async {
    await ns.likePostNoti(post);
  }

  Future<void> unlikePost(Post post) async {
    await ns.unlikePostNoti(post);
  }

  Future<void> readNoti(String nid) async {
    await ns.readNoti(nid);
  }

  Stream<List<Map<String, dynamic>>> streamUnreadNoti() {
    log("stream worked");
    return FirebaseFirestore.instance
        .collection("profile")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> streamAllNoti() {
    log("stream worked");
    return FirebaseFirestore.instance
        .collection("profile")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notifications")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
