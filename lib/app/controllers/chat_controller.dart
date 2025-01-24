import 'package:get/get.dart';

class ChatController extends GetxController {
  // final RxList<Message> messages = RxList.empty();
  final RxString message = RxString("");

  void setMessage(String value) {
    message.value = value;
  }

  // void sendMessage() {
  //   messages.add(Message(content: messageController.text, sender: "user"));
  //   messageController.clear();
  // }
}
