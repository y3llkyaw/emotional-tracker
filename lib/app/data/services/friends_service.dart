import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  final profilePageController = ProfilePageController();

  Future<void> deleteFriendsData(String ownerUid, String uid) async {
    await _firestore
        .collection("profile")
        .doc(ownerUid)
        .collection("friends")
        .doc(uid)
        .delete()
        .then((v) {
      log("delete friend $uid from profile $ownerUid");
    });
  }

  Future<void> createFriendsData(
    String ownerUid,
    String uid,
    String status,
  ) async {
    try {
      await _firestore
          .collection("profile")
          .doc(ownerUid)
          .collection("friends")
          .doc(uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": uid,
        "status": status,
        "read": status == "pending" ? false : true,
      });
    } catch (e) {
      log(e.toString(), name: "created-friend-data");
    }
  }

  Future<void> readFriendRequest(String uid) async {
    try {
      await _firestore
          .collection("profile")
          .doc(_cuid)
          .collection("friends")
          .doc(uid)
          .update({
        "read": true,
      }).then((v) {
        print("read");
      }).onError((e, stackTrace) {
        print(e.toString());
      });
    } catch (e) {
      log("", name: "friend-end");
    }
  }

  Future<String> checkFriendStatus(String uid) async {
    try {
      final doc = await _firestore
          .collection("profile")
          .doc(_cuid)
          .collection("friends")
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.data()!['status'];
      } else {
        return "none";
      }
    } catch (e) {
      return "error";
    }
  }

  Stream<List<String>> friendRequestStream() {
    return _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .where("status", isEqualTo: "pending")
        .snapshots()
        .map((snapshot) {
      var profiles = <String>[];
      for (var doc in snapshot.docs) {
        profiles.add(doc.data()['uid']);
      }
      return profiles;
    }).handleError((error) {
      print("Error fetching friend requests: $error");
      return 0; // Return 0 in case of an error
    });
  }

  Stream<int> noOfFriendRequestStream() {
    return _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .where("status", isEqualTo: "pending")
        .where("read", isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length;
    }).handleError((error) {
      print("Error fetching friend requests: $error");
      return 0; // Return 0 in case of an error
    });
  }

  Stream<String> friendStatusStream(String uid) {
    return _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!['status'] as String;
      } else {
        return "none";
      }
    }).handleError((error) {
      // Handle any errors that might occur
      return "error";
    });
  }

  Future<List> searchFriendsWithName(String query) async {
    final end = '${query.toLowerCase()}\uf8ff'; // Unicode trick
    // search for friends
    var searchResults = [];
    final result = await _firestore
        .collection('profile')
        .where("name_lowercase", isGreaterThanOrEqualTo: query.toLowerCase())
        .where("name_lowercase", isLessThan: end)
        .get();

    for (var r in result.docs) {
      if (r.data()['uid'] != _cuid) {
        searchResults.add(Profile.fromDocument(r.data()));
      }
    }

    if (query.isEmpty) {
      searchResults.clear();
    }
    return searchResults;
  }

  Future<List<Profile>> getFriends() async {
    log("getting friends", name: "friends-services");
    var friends = <Profile>[];
    await _firestore
        .collection("profile")
        .doc(_cuid)
        .collection('friends')
        .where("status", isEqualTo: "friend")
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
