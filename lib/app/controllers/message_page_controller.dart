import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MessagePageController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  final ChatService chatService = ChatService();
  var messages = {}.obs;

  @override
  void onReady() {
    
    super.onReady();
    log("message-page-controller ready");
    getFriendsMessages(); // no need to await if stream is already bound
    messages.bindStream(chatService.getFriendsMessages());
  }

  Future<void> getFriendsMessages() async {
    messages.bindStream(chatService.getFriendsMessages());
  }

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
}
