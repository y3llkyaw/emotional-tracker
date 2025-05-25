import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cuid = FirebaseAuth.instance.currentUser!.uid;

  String _getChatId(String uid1, String uid2) {
    // Create consistent chat ID by sorting UIDs
    List<String> ids = [uid1, uid2];
    ids.sort();
    return "${ids[0]}_${ids[1]}";
  }

  Future<void> sendSystemMessage(SystemMessage sysMsg, String rUid) async {
    String msgTxt = "";
    if (sysMsg == SystemMessage.friend) {
      msgTxt = "you are friends, now.";
    } else {
      msgTxt = "you are friends, now.";
    }
    Message message = Message(
      id: "${_cuid}_${rUid}_${DateTime.now().microsecondsSinceEpoch}",
      uid: rUid,
      read: false,
      message: msgTxt,
      timestamp: Timestamp.now(),
      type: "system",
    );
    await sendMessage(message);
  }

  Future<void> sendMessage(Message message) async {
    try {
      String chatId = _getChatId(_cuid, message.uid);
      await _firestore
          .collection("chats")
          .doc(chatId)
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

  Stream<List<Message>> getUserMessages(String uid) {
    try {
      String chatId = _getChatId(_cuid, uid);
      return _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .limit(30)
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Message(
                    id: doc.data()['id'],
                    uid: doc.data()['uid'],
                    read: doc.data()['read'],
                    message: doc.data()['message'],
                    timestamp: doc.data()['timestamp'],
                    type: doc.data()['type'],
                  ))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteMessage(Message message, String fid) async {
    try {
      String chatId = _getChatId(_cuid, fid);
      return await _firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(message.id)
          .delete()
          .then((v) {});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<Map<String, List<Message>>> getFriendsMessages() {
    return _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .where("status", isEqualTo: "friend")
        .snapshots()
        .asyncMap((snapshot) async {
      Map<String, Stream<List<Message>>> friendMessageStreams = {};

      for (var doc in snapshot.docs) {
        String uid = doc.data()['uid'];
        friendMessageStreams[uid] = getUserMessages(uid);
      }

      return CombineLatestStream.combine2(
          Stream.value(friendMessageStreams.keys.toList()),
          CombineLatestStream.list(friendMessageStreams.values),
          (List<String> uids, List<List<Message>> messages) {
        Map<String, List<Message>> result = {};
        for (var i = 0; i < uids.length; i++) {
          result[uids[i]] = messages[i];
        }
        return result;
      });
    }).switchMap((stream) => stream);
  }

  Stream<int> getUnreadMessageCount() {
    return _firestore
        .collection("profile")
        .doc(_cuid)
        .collection("friends")
        .where("status", isEqualTo: "friend")
        .snapshots()
        .asyncMap((snapshot) async {
      Map<String, Stream<List<Message>>> friendMessageStreams = {};

      for (var doc in snapshot.docs) {
        String uid = doc.data()['uid'];
        friendMessageStreams[uid] = getUserMessages(uid);
      }

      return CombineLatestStream.combine2(
          Stream.value(friendMessageStreams.keys.toList()),
          CombineLatestStream.list(friendMessageStreams.values),
          (List<String> uids, List<List<Message>> messages) {
        int unreadCount = 0;
        for (var message in messages) {
          for (var msg in message) {
            if (msg.read == false && msg.uid == _cuid) {
              unreadCount++;
            }
          }
        }
        return unreadCount;
      });
    }).switchMap((stream) => stream);
  }

  Future<void> readMessage(Message message, String uid) async {
    log("Updating message read status: ${message.id}");
    try {
      String chatId = _getChatId(uid, _cuid);
      DocumentReference docRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection("messages")
          .doc(message.id);

      // Update the "read" status
      await docRef.update({"read": true});
      log("Message ${message.id} marked as read.");

      // Fetch updated document
      DocumentSnapshot updatedDoc = await docRef.get();
      log("Updated Message Data: ${updatedDoc.data()}");

      // return updatedDoc; // Return updated document snapshot
    } catch (e) {
      log('Error updating and fetching read status: $e');
      return; // Return null if an error occurs
    }
  }

  Future<List<Message>> loadMoreMessages(String uid,
      {int limit = 20, Message? lastMessage}) async {
    try {
      String chatId = _getChatId(uid, _cuid);
      Query query = _firestore
          .collection('chats')
          .doc(chatId)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(limit);

      if (lastMessage != null) {
        query = query.startAfter([lastMessage.timestamp]);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Message.fromDocument(data);
      }).toList();
    } catch (e) {
      log('Error loading more messages: $e');
      return [];
    }
  }
}
