import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getNoti() {
    return _firestore
        .collection('profile')
        .doc(_cuid)
        .collection('notifications')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> readNoti(String nid) async {
    await _firestore
        .collection('profile')
        .doc(_cuid)
        .collection('notifications')
        .doc(nid)
        .update({
      "read": true,
    });
  }

  Future<void> deleteNoti(String profileId, String nid) async {
    await _firestore
        .collection('profile')
        .doc(profileId)
        .collection('notifications')
        .doc(nid)
        .delete()
        .then((v) {
      log("delete notifications from $profileId where id is $nid");
    });
  }

  Future<void> likePostNoti(Post post) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore
        .collection('profile')
        .doc(post.uid)
        .collection('notifications')
        .doc("like_${post.id}_$uid")
        .set({
      "id": "like_${post.id}_$uid",
      "type": "like_post",
      "pid": post.id,
      "uid": uid,
      "read": false,
    });
  }

  Future<void> unlikePostNoti(Post post) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore
        .collection('profile')
        .doc(post.uid)
        .collection('notifications')
        .doc("like_${post.id}_$uid")
        .delete();
  }

  Future<void> sendFriendRequstNoti(Profile profile) async {
    await _firestore
        .collection('profile')
        .doc(profile.uid)
        .collection('notifications')
        .doc(_cuid)
        .set({
      "type": "fr",
      "uid": _cuid,
      "read": false,
    });
  }

  Future<void> deleteFriendRequestNotification(String uid) async {
    await _firestore
        .collection('profile')
        .doc(_cuid)
        .collection('notifications')
        .doc(uid)
        .delete();
  }

  Future<void> sendFriendAcceptNoti(Profile profile) async {
    await _firestore
        .collection('profile')
        .doc(profile.uid)
        .collection('notifications')
        .doc(_cuid)
        .set({
      "type": "fr-accept",
      "uid": _cuid,
      "read": false,
    });
  }
}
