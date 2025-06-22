import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/comment_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotiController extends GetxController {
  final NotificationService ns = NotificationService();

  // Original Firestore stream (if needed)
  var notifications = const Stream<List<Map<String, dynamic>>>.empty().obs;

  // ✅ Enriched list with Profile, Post, and Comment
  final enrichedNotifications = <Map<String, dynamic>>[].obs;

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    getAllNotification(); // or call getNotification() if you want unread
  }

  // ✅ Load all notifications (with profiles, posts, and comments if needed)
  Future<void> getAllNotification() async {
    streamAllNoti().listen((notis) async {
      List<Map<String, dynamic>> enrichedList = [];

      for (var n in notis) {
        try {
          final uid = n['uid'];
          final type = n['type'];
          final pid = n['pid'];
          final cid = n['cid'];

          final profile =
              await Get.find<ProfilePageController>().getProfileByUid(uid);

          Post? post;
          dynamic comment;

          if (type == 'like_post' ||
              type == 'comment_post' ||
              type == 'like_comment') {
            post = await Get.find<PostController>().getPostById(pid);
          }
          if (type == 'like_comment' && post != null && cid != null) {
            comment =
                await Get.find<CommentController>().getCommentById(post, cid);
          }
          enrichedList.add({
            ...n,
            'profile': profile,
            'post': post,
            'comment': comment,
          });
        } catch (e) {
          log("⚠️ Error enriching notification: $e");
        }
      }

      enrichedNotifications.value = enrichedList;
    });
  }

  // 🔄 Optionally: for unread notifications only
  Future<void> getNotification() async {
    streamUnreadNoti().listen((notis) async {
      List<Map<String, dynamic>> enrichedList = [];

      for (var n in notis) {
        try {
          final uid = n['uid'];
          final type = n['type'];
          final pid = n['pid'];
          final cid = n['cid'];

          final profile =
              await Get.find<ProfilePageController>().getProfileByUid(uid);

          Post? post;
          dynamic comment;

          if (type == 'like_post' ||
              type == 'comment_post' ||
              type == 'like_comment') {
            post = await Get.find<PostController>().getPostById(pid);
          }

          if (type == 'like_comment' && post != null && cid != null) {
            comment =
                await Get.find<CommentController>().getCommentById(post, cid);
          }

          enrichedList.add({
            ...n,
            'profile': profile,
            'post': post,
            'comment': comment,
          });
        } catch (e) {
          log("⚠️ Error enriching unread notification: $e");
        }
      }

      enrichedNotifications.value = enrichedList;
    });
  }

  // 🟢 Use this if you still want to access raw stream
  Stream<List<Map<String, dynamic>>> streamAllNoti() {
    return FirebaseFirestore.instance
        .collection("profile")
        .doc(_uid)
        .collection("notifications")
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> streamUnreadNoti() {
    return FirebaseFirestore.instance
        .collection("profile")
        .doc(_uid)
        .collection("notifications")
        .where("read", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Notification actions
  Future<void> likePost(Post post) async {
    await ns.likePostNoti(post);
  }

  Future<void> unlikePost(Post post) async {
    await ns.unlikePostNoti(post);
  }

  Future<void> readNoti(String nid) async {
    await ns.readNoti(nid);
  }

  Future<void> commentNoti(String nid) async {
    await ns.readNoti(nid);
  }

  Future<void> markAllUnreadAsRead() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final notiRef = FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .collection("notifications");

    final unreadSnapshot = await notiRef.where("read", isEqualTo: false).get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }

    try {
      await batch.commit();
      log("✅ All unread notifications marked as read");
    } catch (e) {
      log("❌ Error updating notifications: $e");
    }
  }

  Future<void> deleteAllNotifications() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final notiRef = FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .collection("notifications");

    final snapshot = await notiRef.get();

    if (snapshot.docs.isEmpty) {
      log("ℹ️ No notifications to delete.");
      return;
    }

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    try {
      await batch.commit();
      log("✅ All notifications deleted.");
    } catch (e) {
      log("❌ Failed to delete notifications: $e");
    }


  }
}
