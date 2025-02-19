import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OnlineController extends GetxController {
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  var lastSeem = Timestamp.now().obs;
  var friendsOnlineStatus = {}.obs;

  //update user's online status
  Future<void> updateOnlineStatus() async {
    await FirebaseFirestore.instance.collection("isOnline").doc(_cuid).set({
      "uid": _cuid,
      "lastSeem": Timestamp.now(),
    });
  }

  // get user's online status
  Future<void> getFriendOnlineStatus(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("isOnline").doc(uid).get();
    lastSeem.value = doc.data()!["lastSeem"] as Timestamp;
  }

  // get all friends online status
  Future<void> getFriendsOnlineStatus(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("isOnline")
          .doc(uid)
          .get();
      friendsOnlineStatus[uid] = doc.data()!["lastSeem"] as Timestamp;
    } catch (e) {
      print(e.toString());
    }
  }
}
