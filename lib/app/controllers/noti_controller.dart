import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotiController extends GetxController {
  final NotificationService ns = NotificationService();
  var notifications = const Stream<List<Map<String, dynamic>>>.empty().obs;

  @override
  onInit() {
    streamNoti();
    super.onInit();
  }

  Future<void> getNotification() async {
    notifications.value = streamNoti();
  }

  Stream<List<Map<String, dynamic>>> streamNoti() {
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
}
