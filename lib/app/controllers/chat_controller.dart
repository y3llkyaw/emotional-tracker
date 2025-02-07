import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/data/services/chat_service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  final message = ''.obs;
  final showEmoji = false.obs;
  final RxList<Message> messages = <Message>[].obs;
  Stream<List<Message>>? messageStream;

  @override
  void onInit() {
    super.onInit();
  }

  void getUserMessages(String uid) {
    messageStream = chatService.getUserMessages(uid);
    messageStream!.listen((newMessages) {
      messages.value = newMessages;
    });
  }

  void setMessage(String value) {
    message.value = value;
  }

  void clearMessage() {
    message.value = '';
  }

  Future<void> sendMessage(String uid) async {
    final m = Message(
      uid: uid,
      read: false,
      message: message.value,
      timestamp: Timestamp.now(),
      type: "text",
    );
    await chatService.sendMessage(m);
    clearMessage();
  }

  Future<void> sendSticker(String uid) async {
    log(message.toString());
    final m = Message(
      uid: uid,
      read: false,
      message: message.value,
      timestamp: Timestamp.now(),
      type: "sticker",
    );
    await chatService.sendSticker(m);
    clearMessage();
  }
}
