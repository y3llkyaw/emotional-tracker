import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/sources/enums.dart';

class Profile {
  final String uid;
  final String name;
  final Gender gender;
  final Timestamp dateOfBirth;
  final AnimatedEmojiData? emoji;
  final List<AnimatedEmojiData?> recentEmojis;

  final String? avatar;

  Profile({
    required this.uid,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.recentEmojis,
    this.emoji,
    this.avatar,
  });

  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "name": name,
      "gender": gender.toString(),
      "dateOfBirth": dateOfBirth.toString(),
      "emoji": emoji?.toUnicodeEmoji() ?? "",
      "avatar": dateOfBirth.toString(),
      "recentEmojis": [],
    };
  }

  factory Profile.fromDocument(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'],
      name: json['name'],
      gender: Gender.values
          .firstWhere((element) => element.toString() == json['gender']),
      dateOfBirth: json['dob'],
      emoji: _getEmojiFromJson(json),
      avatar: json['avatar'],
      recentEmojis: json['recentEmojis'] ?? [],
    );
  }
  
  static AnimatedEmojiData? _getEmojiFromJson(Map<String, dynamic> json) {
    try {
      return json['emotion'] != null
          ? AnimatedEmojis.fromId(json['emotion'].toString())
          : null; // Return null if 'emotion' is null
    } catch (e) {
      return null; // If any error occurs, return null
    }
  }
}
