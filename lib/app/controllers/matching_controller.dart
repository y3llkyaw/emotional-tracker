import 'dart:async';
import 'dart:developer';

import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchingController extends GetxController {
  final profilePageController = Get.put(ProfilePageController());
  final chatController = Get.put(ChatController());

  final isMatching = false.obs;
  final filterMinAge = 17.obs;
  final filterMaxAge = 45.obs;
  final filterGender = Icons.female.obs;

  StreamSubscription<DatabaseEvent>? _matchSubscription;
  StreamSubscription<DatabaseEvent>? _tempChatSubscription;

  @override
  void onInit() {
    log("✅ MatchingController initialized");
    super.onInit();
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  String _getGenderString(IconData icon) {
    return icon == Icons.male
        ? "Gender.Male"
        : icon == Icons.female
            ? "Gender.Female"
            : "Gender.Both";
  }

  Future<void> startMatching(Profile profile) async {
    try {
      final dob = profile.dob.toDate();
      final age = _calculateAge(dob);
      final genderFilter = _getGenderString(filterGender.value);

      final ref =
          FirebaseDatabase.instance.ref("searching_users/${profile.uid}");
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

      _listenForTempChats();
      _listenForMatches(profile, genderFilter, age);
    } catch (e) {
      log("❌ startMatching error: $e");
    }
  }

  void _listenForTempChats() {
    final ref = FirebaseDatabase.instance.ref("tempChat");
    _tempChatSubscription?.cancel(); // Ensure no duplication
    _tempChatSubscription = ref.onChildAdded.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      log("💬 tempChat users: ${data['users']}");
    });
  }

  void _listenForMatches(Profile profile, String genderFilter, int userAge) {
    final ref = FirebaseDatabase.instance.ref("searching_users");
    _matchSubscription?.cancel();
    _matchSubscription = ref.onChildAdded.listen((event) async {
      final otherUid = event.snapshot.key;
      if (otherUid == profile.uid) return;

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      final otherGender = data["gender"]?.toString().toLowerCase();
      final otherFilterGender = data["filterGender"]?.toString().toLowerCase();
      final otherAge = int.tryParse(data["age"].toString());

      final isGenderMatch = otherGender == genderFilter.toLowerCase() &&
          otherFilterGender == profile.gender.toLowerCase();

      final isAgeMatch = otherAge != null &&
          otherAge >= filterMinAge.value &&
          otherAge <= filterMaxAge.value &&
          userAge >= int.parse(data["filterMinAge"].toString()) &&
          userAge <= int.parse(data["filterMaxAge"].toString());

      if (isGenderMatch && isAgeMatch) {
        log("🎯 Match found with $otherUid");
        final sortedUids = [otherUid, profile.uid]..sort();
        final chatRef =
            FirebaseDatabase.instance.ref("tempChat/${sortedUids.join('_')}");

        await chatRef.set({"users": sortedUids});
        await stopMatching(profile.uid);
        await stopMatching(otherUid!);
        isMatching.value = false;
      } else {
        log("⛔ No match with $otherUid");
      }
    });
  }

  Future<void> stopMatching(String uid) async {
    try {
      await FirebaseDatabase.instance.ref("searching_users/$uid").remove();
      _matchSubscription?.cancel();
      _matchSubscription = null;
      isMatching.value = false;
      log("🛑 Stopped matching for $uid");
    } catch (e) {
      log("❌ stopMatching error: $e");
    }
  }

  @override
  void onClose() {
    _matchSubscription?.cancel();
    _tempChatSubscription?.cancel();
    super.onClose();
  }
}
