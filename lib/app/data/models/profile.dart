import 'package:emotion_tracker/app/sources/enums.dart';

class Profile {
  final String id;
  final String name;
  final Gender gender;
  final DateTime dateOfBirth;

  Profile({
    required this.id,
    required this.name,
    required this.gender,
    required this.dateOfBirth,
  });
}
