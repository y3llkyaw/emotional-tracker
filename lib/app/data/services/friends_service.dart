import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  final ns = NotificationService();
  Future<List> searchFriendsWithName(String query) async {
    // search for friends
    var searchResults = [];
    await _firestore.collection('profile').get().then((value) {
      searchResults.clear();
      for (var element in value.docs) {
        var profile = Profile.fromDocument(element.data());
        if (profile.uid != _cuid &&
            profile.name.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(profile);
        }
      }
    });
    if (query.isEmpty) {
      searchResults.clear();
    }
    return searchResults;
  }

  Future<void> addFriend(Profile profile) async {
    // add friend
    await _firestore
        .collection('profile')
        .doc(profile.uid)
        .collection('friends_request')
        .doc(_cuid)
        .set({
      'uid': _cuid,
      'status': FriendStatus.pending.toString(),
      'isSend': false,
    }).then((value) async {
      await _firestore
          .collection('profile')
          .doc(_cuid)
          .collection('friends_request')
          .doc(profile.uid)
          .set({
        'uid': profile.uid,
        'status': FriendStatus.pending.toString(),
        'isSend': true,
      });
    });
    ns.sendFriendRequstNoti(profile);
  }

  Future<void> removeFriendRequest(Profile profile) async {
    // add friend
    await _firestore
        .collection('profile')
        .doc(profile.uid)
        .collection('friends_request')
        .doc(_cuid)
        .delete();
    await _firestore
        .collection('profile')
        .doc(_cuid)
        .collection('friends_request')
        .doc(profile.uid)
        .delete();
  }

  Future<String?> checkFriendStatus(Profile profile) async {
    // check friend status
    final f = await FirebaseFirestore.instance
        .collection('profile')
        .doc(_cuid)
        .collection('friends_request')
        .doc(profile.uid)
        .get();
    if (f.exists && f.data() != null) {
      log(f.data()!['status']);
      return f.data()!['status'];
    } else {
      return null;
    }
  }

  Future<void> confirmFriendRequest(Profile profile) async {
    // check friend status
    await _firestore
        .collection("profile")
        .doc(profile.uid)
        .collection("friends_request")
        .doc(_cuid)
        .delete();
    await _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends_request")
        .doc(profile.uid)
        .delete();
    await ns.deleteFriendRequestNotification(profile.uid);
    await _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .doc(profile.uid)
        .set({"uid": profile.uid, "timestamp": Timestamp.now()});
    await _firestore
        .collection("profile")
        .doc(profile.uid)
        .collection("friends")
        .doc(_cuid)
        .set({"uid": _cuid, "timestamp": Timestamp.now()});
    ns.sendFriendAcceptNoti(profile);
    log("finished", name: "friends-services");
  }
}
