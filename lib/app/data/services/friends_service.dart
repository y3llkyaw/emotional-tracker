import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  final _ns = NotificationService();
  final profilePageController = ProfilePageController();

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
    _ns.sendFriendRequstNoti(profile);
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
    _ns.deleteFriendRequestNotification(profile.uid);
  }

  Future<String?> checkFriendStatus(Profile profile) async {
    // check friend status
    final f = await FirebaseFirestore.instance
        .collection('profile')
        .doc(_cuid)
        .collection('friends_request')
        .doc(profile.uid)
        .get();

    final friends = await FirebaseFirestore.instance
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .doc(profile.uid)
        .get();

    final noti = await FirebaseFirestore.instance
        .collection("profile")
        .doc(_cuid)
        .collection("notifications")
        .doc(profile.uid)
        .get();

    if (noti.exists && noti.data() != null) {
      if (noti.data()!["type"] == "fr") {
        return "FriendStatus.fr";
      }
    }

    if (friends.exists && friends.data() != null) {
      return "FriendStatus.friend";
    }
    if (f.exists && f.data() != null) {
      log(f.data()!['status'], name: "not-friend");
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
    await _ns.deleteFriendRequestNotification(profile.uid);
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
    _ns.sendFriendAcceptNoti(profile);

    log("finished", name: "friends-services");
  }

  Future<List<Profile>> getFriends() async {
    log("getting friends", name: "friends-services");
    var friends = <Profile>[];
    await _firestore
        .collection("profile")
        .doc(_cuid)
        .collection('friends')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        final friend =
            await profilePageController.getProfileByUid(element.data()["uid"]);
        friends.add(friend);
      }
      return friends;
    }).onError((error, stackTrace) {
      return friends;
    });
    return friends;
  }
}
