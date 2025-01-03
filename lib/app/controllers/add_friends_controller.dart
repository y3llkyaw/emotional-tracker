import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddFriendsController extends GetxController {
  var searchResults = <Profile>[].obs;
  Future<void> searchFriends(String query) async {
    // search for friends
    await FirebaseFirestore.instance
        .collection('profile')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get()
        .then((value) {
      searchResults.clear();
      for (var element in value.docs) {
        searchResults.add(Profile.fromDocument(element.data()));
      }
    });
    if (query.isEmpty) {
      searchResults.clear();
    }
  }

  Future<void> addFriend(Profile profile) async {
    // add friend
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(profile.uid)
        .collection('friends_requests')
        .add({
      'friend_requests': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
