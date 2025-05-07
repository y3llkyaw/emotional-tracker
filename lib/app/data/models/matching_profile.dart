class MatchingProfile {
  final int age;
  final String gender;
  final String filterGender;
  final int filterMinAge;
  final int filterMaxAge;
  final bool isIdel;
  final String? mateId;

  MatchingProfile({
    required this.age,
    required this.gender,
    required this.filterMinAge,
    required this.filterMaxAge,
    required this.filterGender,
    required this.isIdel,
    this.mateId,
  });

  factory MatchingProfile.fromDocument(Map<String, dynamic> json) {
    return MatchingProfile(
      age: json['age'],
      gender: json['gender'],
      isIdel: json['isIdel'],
      filterMinAge: json['filterMinAge'],
      filterMaxAge: json['filterMaxAge'],
      filterGender: json['filterGender'],
      mateId: json["mateId"]
    );
  }
}
