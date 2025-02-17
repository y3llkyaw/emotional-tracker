import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String uid;
  bool read;
  final String message;
  final Timestamp timestamp;
  final String type;

  Message({
    required this.id,
    required this.uid,
    required this.read,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  factory Message.fromDocument(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      uid: json['uid'],
      read: json['read'],
      message: json['message'],
      timestamp: json['timestamp'],
      type: json["type"],
    );
  }
  Map<String, dynamic> toDocument() {
    return {
      "id": id,
      "uid": uid,
      "read": read,
      "message": message,
      "timestamp": timestamp,
      "type": type,
    };
  }
}

class TextMessage extends Message {
  TextMessage({
    required String id,
    required String uid,
    required bool read,
    required String message,
    required Timestamp timestamp,
    required String type,
  }) : super(
          id: id,
          uid: uid,
          read: read,
          message: message,
          timestamp: timestamp,
          type: type,
        );
}
