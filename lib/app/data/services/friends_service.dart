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

  Future<List> searchFriendsWithUsername(String? query) async {
    if (query == null) {
      return [];
    }

    // search for friends
    var searchResults = [];
    final result = await _firestore
        .collection('usernames')
        .where("username", isEqualTo: query.split("@")[1])
        .get();

    for (var r in result.docs) {
      if (r.data()['uid'] != _cuid) {
        final profile =
            await profilePageController.getProfileByUid(r.data()["uid"]);
        searchResults.add(profile);
      }
    }
    if (query.isEmpty) {
      searchResults.clear();
    }

    return searchResults;
  }

  Future<List<Profile>> searchUsersByName(String? name) async {
    try {
      var searchResults = [];
      if (name == null || name.trim().isEmpty) return [];

      final queryText = name.toLowerCase();
      // final endText = '$queryText\uf8ff'; // matches prefix

      final snapshot = await _firestore
          .collection('profile')
          .orderBy('name_lowercase')
          .startAt([queryText]).get();

      for (var doc in snapshot.docs) {
        if (!searchResults.contains(doc.data())) {
          searchResults.add(doc.data());
        }
      }
      return snapshot.docs
          .where((doc) => doc.data()['uid'] != _cuid) // avoid self
          .map((doc) => Profile.fromDocument(doc.data()))
          .toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Profile?>> getFriends() async {
    log("getting friends", name: "friends-services");
    var friends = <Profile?>[];
    try {
      await _firestore
          .collection("profile")
          .doc(_cuid)
          .collection('friends')
          .where("status", isEqualTo: "friend")
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          return [];
        }
        for (var element in value.docs) {
          final friend = await profilePageController
              .getProfileByUid(element.data()["uid"]);
          friends.add(friend);
        }
        return friends;
      }).onError((error, stackTrace) {
        log(error.toString(), error: error.toString(), name: "error ouccur");
        print(friends);
        return friends;
      });
      return friends;
    } catch (e) {
      print(e.toString());
      return friends;
    }
  }
}
