import 'package:emotion_tracker/app/data/models/profile.dart';

class Post {
  String? id;
  final String uid;
  final String type;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  Profile? profile;

  Post({
    this.id,
    required this.uid,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.type = "text", // Default type
    this.imageUrl,
    this.profile,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      uid: json['uid'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? "text",
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
