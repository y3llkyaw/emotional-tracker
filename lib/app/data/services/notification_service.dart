import 'package:cloud_firestore/cloud_firestore.dart';
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
        .update({"read": true});
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
