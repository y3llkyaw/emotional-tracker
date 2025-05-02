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
    log("🔧 MatchingController initialized");
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
      final uid = profile.uid;
      final ref = FirebaseDatabase.instance.ref("searching_users/$uid");

      final genderFilterValue = filterGender.value == Icons.male
          ? "Gender.Male"
          : filterGender.value == Icons.female
              ? "Gender.Female"
              : "Gender.Both";

      await ref.set({
        "gender": profile.gender,
        "age": age,
        "filterGender": genderFilterValue,
        "filterMaxAge": filterMaxAge.value,
        "filterMinAge": filterMinAge.value,
        "timestamp": ServerValue.timestamp,
      });

      await ref.onDisconnect().remove();

      isMatching.value = true;

      _listenForMatch(profile, genderFilterValue);
      _listenForRoom(profile.uid);
    } catch (e) {
      log("❌ startMatching error: $e");
    }
  }

  void _listenForMatch(Profile profile, String genderFilter) {
    final ref = FirebaseDatabase.instance.ref("searching_users");

    _matchSubscription = ref.onChildAdded.listen((event) async {
      final otherUid = event.snapshot.key;
      if (otherUid == profile.uid) return;

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      final gender = data["gender"]?.toString().toLowerCase();
      final age = int.tryParse(data["age"].toString());
      final otherMinAge = int.tryParse(data["filterMinAge"].toString());
      final otherMaxAge = int.tryParse(data["filterMaxAge"].toString());

      final userAge = _calculateAge(profile.dob.toDate());

      final isGenderMatch = (gender == genderFilter.toLowerCase() ||
              genderFilter == "gender.both") &&
          (data["filterGender"]?.toString().toLowerCase() ==
                  profile.gender.toLowerCase() ||
              data["filterGender"]?.toString().toLowerCase() == "gender.both");

      final isAgeMatch = age != null &&
          age >= filterMinAge.value &&
          age <= filterMaxAge.value &&
          userAge >= (otherMinAge ?? 0) &&
          userAge <= (otherMaxAge ?? 100);

      if (isGenderMatch && isAgeMatch) {
        log("🎯 Match found: $otherUid");
        await stopMatching(profile.uid);
        await stopMatching(otherUid!);
        final sorted = [profile.uid, otherUid]..sort();
        final roomId = "${sorted[0]}_${sorted[1]}";

        final roomRef = FirebaseDatabase.instance
            .ref("searching_users/matched_users/$roomId");
        await roomRef.set({
          "users": sorted,
        });
        isMatching.value = false;
      } else {
        log("❌ Not a match: $otherUid");
      }
    });
  }

  void _listenForRoom(String uid) {
    final roomRef =
        FirebaseDatabase.instance.ref("searching_users/matched_users");

    _roomSubscription = roomRef.onChildAdded.listen((event) {
      final roomId = event.snapshot.key ?? "";
      final users = List.from(event.snapshot.child("users").value as List);

      if (users.contains(uid)) {
        log("💬 Navigating to TempChatPage: $roomId");
        Get.to(() => TempChatPage(chatRoomId: roomId));
      }
    });
  }

  Future<void> stopMatching(String uid) async {
    try {
      log("🛑 Stopping match for $uid");
      await FirebaseDatabase.instance.ref("searching_users/$uid").remove();
      _matchSubscription?.cancel();
      _matchSubscription = null;

      isMatching.value = false;
    } catch (e) {
      log("❌ stopMatching error: $e");
    }
  }

  Future<void> removeRoom(String roomId) async {
    try {
      log("🛑 Stopping room for $roomId");
      await FirebaseDatabase.instance
          .ref("searching_users/matched_users/$roomId")
          .remove();
      _roomSubscription?.cancel();
      _roomSubscription = null;
    } catch (e) {
      log("❌ stopMatching error: $e");
    }
  }

  @override
  void onClose() {
    _matchSubscription?.cancel();
    _roomSubscription?.cancel();
    super.onClose();
  }
}
