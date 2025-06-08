import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';

class Comment {
  final String id;
  final String postId;
  final String uid;
  final String comment;
  final List<String>? likes;
  final List<Comment>? replies;
  final DateTime createdAt;
  final DateTime updatedAt;
  Profile? profile;

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.likes = const [],
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is Timestamp) {
        return value.toDate();
      } else {
        return DateTime.now();
      }
    }

    return Comment(
      id: json['id'].toString(),
      postId: json['postId'].toString(),
      uid: json['uid'].toString(),
      comment: json['comment'],
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => e as Comment)
              .toList() ??
          [],
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'postId': postId,
  //     'uid': uid,
  //     'comment': comment,
  //     'likes': likes,
  //     'replies': replies,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //   };
  // }
}
