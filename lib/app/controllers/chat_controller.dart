import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  // final RxList<Message> messages = RxList.empty();
  final message = ''.obs;
  final showEmoji = false.obs;

  void setMessage(String value) {
    message.value = value;
    print(message);
  }

  void clearMessage() {
    message.value = '';
  }
}
