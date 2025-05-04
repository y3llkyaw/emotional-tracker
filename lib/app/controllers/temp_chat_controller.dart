import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class TempChatController extends GetxController {
  var timeRemaining = "".obs;
  var roomId = "".obs;

  StreamSubscription<DatabaseEvent>? _roomSubscription;

  void listenRoom() {
    log("listening room");
    final ref = FirebaseDatabase.instance.ref("matched_users}");
    _roomSubscription = ref.onChildRemoved.listen((event) {
      print(event.snapshot.key);
      _roomSubscription?.cancel();
    });
  }
}
