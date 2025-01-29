import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uid;
  final bool read;
  final String message;
  final Timestamp timestamp;

  const Message({
    required this.uid,
    required this.read,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromDocument(Map<String, dynamic> json) {
    return Message(
      uid: json['uid'],
      read: json['read'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "read": read,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
