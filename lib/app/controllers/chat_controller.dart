import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/data/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  final message = ''.obs;
  final showEmoji = false.obs;
  final RxList<Message> messages = <Message>[].obs;
  Stream<List<Message>>? messageStream;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;
  var shareList = [].obs;
  var isLoading = false.obs;

  void getUserMessages(String uid) {
    messageStream = chatService.getUserMessages(uid);
    messageStream!.listen((newMessages) {
      messages.value = newMessages;
    });
  }

  void loadMoreMessages(String uid) async {
    isLoading.value = true;
    log("loading more message");
    final messagesList =
        await chatService.loadMoreMessages(uid, lastMessage: messages.last);
    messages.addAll(messagesList);
    isLoading.value = false;
  }

  void setMessage(String value) {
    message.value = value;
  }

  void clearMessage() {
    message.value = '';
  }

  Future<void> sendMessage(String uid) async {
    final m = Message(
      id: "${_cuid}_${uid}_${DateTime.now().microsecondsSinceEpoch}",
      uid: uid,
      read: false,
      message: message.value,
      timestamp: Timestamp.now(),
      type: "text",
    );
    if (m.message == "") {
      return;
    }
    await chatService.sendMessage(m).onError((error, stack) {});
    clearMessage();
  }

  Future<void> sendSticker(String uid, String stickerData) async {
    final m = Message(
      id: "${_cuid}_${uid}_${DateTime.now().microsecondsSinceEpoch}",
      uid: uid,
      read: false,
      message: stickerData,
      timestamp: Timestamp.now(),
      type: "sticker",
    );
    if (m.message == "") {
      return;
    }
    await chatService.sendMessage(m);
    clearMessage();
  }

  Future<void> sendJournal(String uid, Journal journal) async {
    String jid = "journal_${journal.date.toString().split(" ")[0]}";

    final m = Message(
      id: "${_cuid}_${uid}_${DateTime.now().microsecondsSinceEpoch}",
      uid: uid,
      read: false,
      message: jid,
      timestamp: Timestamp.now(),
      type: "journal",
    );
    if (m.message == "") {
      return;
    }
    await chatService.sendMessage(m);
    clearMessage();
  }

  Future<void> readMessage(Message message, String uid) async {
    await chatService.readMessage(message, uid).then((v) {});
  }
}
