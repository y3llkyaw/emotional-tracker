import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Journal {
  final String uid;
  final DateTime date;
  final String content;
  final AnimatedEmojiData emotion;
  final int value;

  const Journal({
    required this.uid,
    required this.date,
    required this.content,
    required this.emotion,
    required this.value,
  });

  factory Journal.fromDocument(Map<String, dynamic> json) {
    return Journal(
      uid: json['uid'],
      date: (json['date'] as Timestamp).toDate(),
      content: json['content'],
      emotion: AnimatedEmojis.fromId(json['emotion'].toString()),
      value: json['value'],
    );
  }
}
