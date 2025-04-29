import 'dart:async';
import 'dart:developer';

import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
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

      await ref.set({
        "gender": profile.gender,
        "age": age,
        "timestamp": ServerValue.timestamp,
      });

      await ref.onDisconnect().remove();

      isMatching.value = true;
      listenForMatch(profile); // 🔁 Start listening for matches
    } catch (e) {
      log("❌ Error in startMatching: $e");
    }
  }

  void listenForMatch(Profile profile) {
    final ref = FirebaseDatabase.instance.ref("searching_users");

    _matchSubscription = ref.onChildAdded.listen((event) async {
      final data = event.snapshot.value as Map?;
      if (data == null) return;

      final otherUid = event.snapshot.key!;
      if (otherUid == profile.uid) return; // ignore self

      final gender = data['gender']?.toString().toLowerCase() ?? '';
      final age = data['age'] is int
          ? data['age']
          : int.tryParse(data['age'].toString() ?? '0') ?? 0;

      final isGenderMatch = filterGender.value == Icons.female
          ? gender == 'Gender.Female'
          : gender == 'Gender.Male';

      final isAgeMatch = age >= filterMinAge.value && age <= filterMaxAge.value;

      if (isGenderMatch && isAgeMatch) {
        log("🎯 Match found with $otherUid!");

        // Optional: remove both from matchmaking pool
        await stopMatching(profile);
        await FirebaseDatabase.instance
            .ref("searching_users/$otherUid")
            .remove();

        // Notify the user (replace with your UI flow)
        Get.snackbar("Match Found", "You matched with user: $otherUid");

        // Optionally: Save to 'matches' node or open chat
      }
    });
  }

  Future<void> stopMatching(Profile profile) async {
    try {
      log("🛑 Stopping matching for UID: ${profile.uid}");
      final ref =
          FirebaseDatabase.instance.ref("searching_users/${profile.uid}");
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
    super.onClose();
  }
}
