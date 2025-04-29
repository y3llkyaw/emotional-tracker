import 'dart:async';
import 'dart:developer';

import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/temp_chat_page/temp_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchingController extends GetxController {
  final profilePageController = Get.put(ProfilePageController());
  final isMatching = false.obs;

  final filterMinAge = 17.obs;
  final filterMaxAge = 45.obs;
  final filterGender = Icons.female.obs;

  StreamSubscription<DatabaseEvent>? _matchSubscription;
  StreamSubscription<DatabaseEvent>? _roomSubscription;

  @override
  void onInit() {
    super.onInit();
    log("matching-controller-created");
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> startMatching(Profile profile) async {
    try {
      final dob = profilePageController.userProfile.value?.dob.toDate();
      if (dob == null) throw Exception("DOB is null");

      final age = _calculateAge(dob);

      log("🚀 Starting matching for UID: ${profile.uid}");
      final ref =
          FirebaseDatabase.instance.ref("searching_users/${profile.uid}");

      final genderFilter = filterGender.value == Icons.male
          ? "Gender.Male"
          : filterGender.value == Icons.female
              ? "Gender.Female"
              : "Gender.Both";

      await ref.set({
        "gender": profile.gender,
        "age": age,
        "filterGender": genderFilter,
        "filterMaxAge": filterMaxAge.value,
        "filterMinAge": filterMinAge.value,
        "timestamp": ServerValue.timestamp,
      });

      await ref.onDisconnect().remove();

      isMatching.value = true;
      listenForMatch(
        profile,
        genderFilter,
        filterMaxAge.value,
        filterMinAge.value,
      ); // 🔁 Start listening for matches
    } catch (e) {
      log("❌ Error in startMatching: $e");
    }
  }

  void listenForMatch(
    Profile profile,
    String genderFilter,
    int filterMaxAge,
    int filterMinAge,
  ) {
    final ref = FirebaseDatabase.instance.ref("searching_users");

    _matchSubscription = ref.onChildAdded.listen((event) async {
      final otherUid = event.snapshot.key;

      // Avoid comparing with your own profile
      if (otherUid == profile.uid) return;

      final rawData = event.snapshot.value as Map<Object?, Object?>;
      final data = rawData.map((key, value) => MapEntry(key.toString(), value));

      final gender = data["gender"]?.toString().toLowerCase();
      final age = int.tryParse(data["age"].toString());

      final otherFilterMinAge = int.tryParse(data["filterMinAge"].toString());
      final otherFilterMaxAge = int.tryParse(data["filterMaxAge"].toString());

      var isGenderMatch = false;

      isGenderMatch = (gender == genderFilter.toLowerCase() ||
              genderFilter.toLowerCase() == "gender.both") &&
          (data["filterGender"]?.toString().toLowerCase() ==
                  profile.gender.toLowerCase() ||
              data["filterGender"]?.toString().toLowerCase() == "gender.both");

      final isAgeMatch = age != null &&
          age >= filterMinAge &&
          age <= filterMaxAge &&
          _calculateAge(profile.dob.toDate()) >= otherFilterMinAge! &&
          _calculateAge(profile.dob.toDate()) <= otherFilterMaxAge!;

      if (isGenderMatch && isAgeMatch) {
        log("🎯 Match found: UID = $otherUid, Gender = $gender, Age = $age");
        var sorted = [otherUid, profile.uid]..sort();
        final ref = FirebaseDatabase.instance
            .ref('searching_users/matched_users/${sorted[0]}_${sorted[1]}');
        await ref.set({
          "users": [otherUid, profile.uid]
        });
      } else {
        log("❌ Not a match: UID = $otherUid, Gender = $gender, Age = $age");
      }
    });

    final roomRef =
        FirebaseDatabase.instance.ref("searching_users/matched_users");

    _roomSubscription = roomRef.onChildAdded.listen((event) {
      event.snapshot.key!.contains(profile.uid)
          ? Get.to(() => const TempChatPage())
          : null;
    });
  }

  Future<void> stopMatching(String uid) async {
    try {
      log("🛑 Stopping matching for UID: $uid");
      final ref = FirebaseDatabase.instance.ref("searching_users/$uid");
      await ref.remove();

      _matchSubscription?.cancel();
      _matchSubscription = null;

      isMatching.value = false;
    } catch (e) {
      log("❌ Error in stopMatching: $e");
    }
  }

  @override
  void onClose() {
    _matchSubscription?.cancel();
    _roomSubscription?.cancel();
    super.onClose();
  }
}
