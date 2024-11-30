import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/sources/enums.dart';

class Profile {
  final String uid;
  final String name;
  final Gender gender;
  final Timestamp dateOfBirth;

  Profile({
    required this.uid,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toDocument() {
    return {
      "uid": uid,
      "name": name,
      "gender": gender.toString(),
      "dateOfBirth": dateOfBirth.toString(),
    };
  }

  factory Profile.fromDocument(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'],
      name: json['name'],
      gender: Gender.values
          .firstWhere((element) => element.toString() == json['gender']),
      dateOfBirth: json['dob'],
    );
  }
}
