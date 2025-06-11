import 'dart:developer';
import 'dart:ui';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile {
  final String uid;
  final String name;
  final String? bio;
  final String nameLowerCase;
  final String gender;
  final Timestamp dob;
  // final AnimatedEmojiData? emoji;
  final List<AnimatedEmojiData> recentEmojis;
  final String? avatar;

  Profile({
    required this.uid,
    required this.name,
    this.bio,
    required this.nameLowerCase,
    required this.gender,
    required this.dob,
    required this.recentEmojis,
    this.avatar,
  });

  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "name": name,
      "bio": bio,
      "name_lowercase": nameLowerCase,
      "gender": gender.toString(),
      "dob": dob, // Store Timestamp directly
      // "emoji": emoji?.id ?? "", // store emoji ID, not unicode
      "recentEmojis": recentEmojis.map((e) => e.id).toList(),
      "avatar": avatar,
    };
  }

  factory Profile.fromDocument(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'],
      name: json['name'],
      bio: json['bio'],
      nameLowerCase: json['name_lowercase'],
      gender: json['gender'],
      dob: _parseTimestamp(json['dob']),
      recentEmojis: _getEmojiList(json),
      avatar: json['avatar'],
    );
  }

  static Timestamp _parseTimestamp(dynamic dobField) {
    try {
      return dobField is Timestamp
          ? dobField
          : Timestamp.fromDate(DateTime.parse(dobField.toString()));
    } catch (e) {
      log('DOB parse error: $e');
      return Timestamp.now(); // fallback
    }
  }

  // static AnimatedEmojiData? _getEmojiFromJson(Map<String, dynamic> json) {
  //   try {
  //     return json['emoji'] != null
  //         ? AnimatedEmojis.fromId(json['emoji'].toString())
  //         : null;
  //   } catch (e) {
  //     log('Emoji parse error: $e');
  //     return null;
  //   }
  // }

  static List<AnimatedEmojiData> _getEmojiList(Map<String, dynamic> json) {
    try {
      final rawList = json["recentEmojis"];
      if (rawList is! List || rawList.isEmpty) return [];

      return rawList
          .where((e) => e != null && e.toString().isNotEmpty)
          .map((e) => AnimatedEmojis.fromId(e.toString()))
          .toList();
    } catch (e) {
      log('Recent emojis parse error: $e');
      return [];
    }
  }

  // Age getter
  int get age {
    final now = DateTime.now();
    final birthDate = dob.toDate();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }

  Color get color {
    return gender.toLowerCase().toString() == "gender.female"
        ? Colors.pink
        : Colors.blue;
  }

  IconData get genderIcon {
    return gender.toLowerCase().toString() == "gender.female"
        ? Icons.female
        : Icons.male;
  }

  String get genderString {
    return gender.toLowerCase().toString() == "gender.female"
        ? "Female"
        : "Male";
  }
}
