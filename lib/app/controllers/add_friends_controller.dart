import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/data/services/friends_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddFriendsController extends GetxController {
  var searchResults = [].obs;
  final cuid = FirebaseAuth.instance.currentUser!.uid;
  final _friendService = FriendService();

  Future<void> searchFriendsWithName(String query) async {
    searchResults.value = await _friendService.searchFriendsWithName(query);
  }

  Future<void> addFriend(Profile profile) async {
    // add friend
    await _friendService.addFriend(profile);
  }

  Future<void> removeFriendRequest(Profile profile) async {
    // add friend
    await _friendService.removeFriendRequest(profile);
  }

  Future<String?> checkFriendStatus(Profile profile) async {
    // check friend status
    final status = await _friendService.checkFriendStatus(profile);
    return status;
  }
}
