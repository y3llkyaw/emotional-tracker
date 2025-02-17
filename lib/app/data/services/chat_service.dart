import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage(Message message) async {
    try {
      await _firestore
          .collection("profile")
          .doc(_cuid)
          .collection("chat")
          .doc(message.uid)
          .collection("messages")
          .doc(message.id)
          .set(message.toDocument())
          .then(
        (v) {
          log("send");
        },
      ).onError((e, stackTrace) {
        log(e.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendSticker(Message message) async {
    try {
      await _firestore
          .collection("profile")
          .doc(_cuid)
          .collection("chat")
          .doc(message.uid)
          .collection("messages")
          .doc(message.id)
          .set(message.toDocument())
          .then((v) => log("sent sticker successfully"))
          .onError((e, stackTrace) {
        log(e.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<Message>> getUserMessages(String uid) {
    try {
      var sentMessagesStream = _firestore
          .collection("profile")
          .doc(_cuid)
          .collection("chat")
          .doc(uid)
          .collection("messages")
          .limit(30)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Message(
                    id: doc.data()['id'],
                    uid: uid,
                    read: doc.data()['read'],
                    message: doc.data()['message'],
                    timestamp: doc.data()['timestamp'],
                    type: doc.data()['type'],
                  ))
              .toList());

      var receivedMessagesStream = _firestore
          .collection("profile")
          .doc(uid)
          .collection("chat")
          .doc(_cuid)
          .collection("messages")
          .limit(30)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Message(
                    id: doc.data()['id'],
                    uid: _cuid,
                    read: doc.data()['read'],
                    message: doc.data()['message'],
                    timestamp: doc.data()['timestamp'],
                    type: doc.data()['type'],
                  ))
              .toList());

      // Merge both streams and sort messages by timestamp
      return CombineLatestStream.combine2(
        sentMessagesStream,
        receivedMessagesStream,
        (List<Message> sent, List<Message> received) {
          List<Message> allMessages = [...sent, ...received];
          allMessages.sort((a, b) => b.timestamp
              .compareTo(a.timestamp)); // Sort by timestamp (latest first)
          return allMessages;
        },
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> readMessage(Message message) async {
    log("Updating message read status: ${message.id}");
    try {
      // DatabaseReference ref = FirebaseDatabase.instance
      //     .ref("/profile/${message.uid}/chat/$_cuid/messages/${message.id}");

      // await ref.set({
      //   "name": "John",
      //   "age": 18,
      //   "address": {"line1": "100 Mountain View"}
      // });
    } catch (e) {
      log('Error updating read status: $e');
    }
  }
}
