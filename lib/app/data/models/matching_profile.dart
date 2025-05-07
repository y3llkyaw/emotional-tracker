class MatchingProfile {
  final int age;
  final String gender;
  final String filterGender;
  final int filterMinAge;
  final int filterMaxAge;

  MatchingProfile({
    required this.age,
    required this.gender,
    required this.filterMinAge,
    required this.filterMaxAge,
    required this.filterGender,
  });

  factory MatchingProfile.fromDocument(Map<String, dynamic> json) {
    return MatchingProfile(
      age: json['age'],
      gender: json['gender'],
      filterMinAge: json['filterMinAge'],
      filterMaxAge: json['filterMaxAge'],
      filterGender: json['filterGender'],
    );
  }
}
