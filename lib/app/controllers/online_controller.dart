import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OnlineController extends GetxController {
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  var lastSeem = Timestamp.now().obs;

  //update user's online status
  Future<void> updateOnlineStatus() async {
    await FirebaseFirestore.instance.collection("isOnline").doc(_cuid).set({
      "uid": _cuid,
      "last_seem": Timestamp.now(),
    });
  }

  // get user's online status
  Future<void> getFriendOnlineStatus(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection("isOnline").doc(uid).get();
    lastSeem.value = doc.data()!["lastseem"] as Timestamp;
  }
}
