import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uid;
  final bool read;

  final String message;
  final Timestamp timestamp;
  final String type;

  const Message({
    required this.uid,
    required this.read,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  factory Message.fromDocument(Map<String, dynamic> json) {
    return Message(
      uid: json['uid'],
      read: json['read'],
      message: json['message'],
      timestamp: json['timestamp'],
      type: json["type"],
    );
  }
  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "read": read,
      "message": message,
      "timestamp": timestamp,
      "type": type,
    };
  }
}