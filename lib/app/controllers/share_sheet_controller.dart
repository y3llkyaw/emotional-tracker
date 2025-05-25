import 'dart:developer';

import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:get/get.dart';

class ShareSheetController extends GetxController {
  final chatController = Get.put(ChatController());
  var shareList = [].obs;

  Future<void> shareSheet(Journal jid) async {
    try {
      for (var uid in shareList) {
        await chatController.sendJournal(uid, jid);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
