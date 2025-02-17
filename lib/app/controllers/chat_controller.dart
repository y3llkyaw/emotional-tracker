import 'package:cloud_firestore/cloud_firestore.dart';
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
    await chatService.sendMessage(m).onError((error, stack) {
      print(error);
    });
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
    await chatService.sendSticker(m);
    clearMessage();
  }

  Future<void> readMessage(Message message) async {
    await chatService.readMessage(message);
  }
}
