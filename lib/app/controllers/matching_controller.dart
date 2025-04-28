import 'dart:developer';

import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchingController extends GetxController {
  final profilePageController = Get.put(ProfilePageController());
  var isMatching = false.obs;

  var filterMinAge = 17.obs;
  var filterMaxAge = 45.obs;
  var filterGender = Icons.female.obs;

  @override
  void onInit() {
    super.onInit();
    log("matching-controller-created");
  }

  Future<void> startMatching(Profile profile) async {
    try {
      profilePageController.userProfile.value!.dob;
      DateTime dob = profilePageController.userProfile.value!.dob
          .toDate(); // assuming it's not null
      DateTime today = DateTime.now();

      int age = today.year - dob.year;

      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }

      log("start matching");
      final DatabaseReference ref =
          FirebaseDatabase.instance.ref("searching_users/${profile.uid}");
      await ref.set({
        "gender": profile.gender,
        "age": age,
        "timestamp": ServerValue.timestamp,
      }).then((v) {
        isMatching.value = true;
      });

      await ref.onDisconnect().remove();
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  Future stopMatching(Profile profile) async {
    try {
      log("stop matching");
      final DatabaseReference ref =
          FirebaseDatabase.instance.ref("searching_users/${profile.uid}");

      await ref.remove().then((v) {
        isMatching.value = false;
      });
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }
}
