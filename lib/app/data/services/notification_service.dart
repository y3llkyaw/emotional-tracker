import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
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
    await _firestore
        .collection('profile')
        .doc(post.uid)
        .collection('notifications')
        .doc("like_${post.id}_$_cuid")
        .set({
      "id": "like_${post.id}_$_cuid",
      "type": "like_post",
      "pid": post.id,
      "uid": _cuid,
      "read": false,
      "created_at": Timestamp.now()
    });
  }

  Future<void> likeCommentNoti(Post post, Comment comment) async {
    await _firestore
        .collection('profile')
        .doc(comment.uid)
        .collection('notifications')
        .doc("like_comment_${_cuid}_${comment.id}")
        .set({
      "id": "like_comment_${_cuid}_${comment.id}",
      "type": "like_comment",
      "pid": post.id,
      "cid": comment.id,
      "uid": _cuid,
      "read": false,
      "created_at": Timestamp.now()
    });
  }

  Future<void> unlikePostNoti(Post post) async {
    await _firestore
        .collection('profile')
        .doc(post.uid)
        .collection('notifications')
        .doc("like_${post.id}_$_cuid")
        .delete();
  }

  Future<void> commentNoti(Post post, Comment comment) async {
    await _firestore
        .collection('profile')
        .doc(post.uid)
        .collection('notifications')
        .doc("comment_${post.id}_${comment.id}")
        .set({
      "id": "comment_${post.id}_${comment.id}",
      "pid": post.id,
      "type": "comment_post",
      "uid": _cuid,
      "read": false,
      "created_at": Timestamp.now(),
    });
  }
}
