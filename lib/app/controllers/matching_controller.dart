import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/matching_profile.dart';
import 'package:emotion_tracker/app/ui/pages/review_profile_page/review_profile_page.dart';
import 'package:emotion_tracker/app/ui/pages/temp_chat_page/temp_chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchingController extends GetxController {
  final profilePageController = Get.put(ProfilePageController());
  final isMatching = false.obs;
  final isInChat = false.obs;

  final filterMinAge = 17.obs;
  final filterMaxAge = 45.obs;
  final filterGender = "gender.male".obs;

  StreamSubscription<DatabaseEvent>? _matchSubscription;
  StreamSubscription<DatabaseEvent>? _roomSubscription;
  StreamSubscription<DatabaseEvent>? _chatStatusSubscription;

  @override
  void onInit() async {
    super.onInit();
    await profilePageController.getCurrentUserProfile();
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

  Future<void> setMatchingData() async {
    final userId = profilePageController.userProfile.value?.uid ?? "";
    final age =
        _calculateAge(profilePageController.userProfile.value!.dob.toDate());
    final ref = FirebaseDatabase.instance.ref("searching_users/$userId");

    await ref
        .set({
          "age": age,
          "gender":
              profilePageController.userProfile.value!.gender.toLowerCase(),
          "filterMinAge": filterMinAge.value,
          "filterMaxAge": filterMaxAge.value,
          "filterGender": filterGender.value,
          "isIdel": true,
          "isOnline": true,
          "mateId": null,
          "inChat": false,
        })
        .then((v) {})
        .onError((e, stackTrace) {
          log(e.toString(), error: e, name: "error-seting-matching-data");
        })
        .then((v) {
          isMatching.value = true;
        });
    ref.onDisconnect().remove();
  }

  Future<void> removeMatchingData() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    final ref = FirebaseDatabase.instance
        .ref("searching_users/${FirebaseAuth.instance.currentUser?.uid}");
    await ref.remove().then((v) {
      isMatching.value = false;
      isInChat.value = false;
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      _chatStatusSubscription?.cancel();
      log("Removed matching data");
    }).onError((e, stackTrace) {
      log(e.toString(), error: e, name: "error-removing-matching-data");
      isMatching.value = true;
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      _chatStatusSubscription?.cancel();
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true);
    });
  }

  void findingMatchPerson() async {
    await setMatchingData();
    final listRef = FirebaseDatabase.instance.ref("searching_users");
    log("Listening for matching users");
    _matchSubscription = listRef.onValue.listen((event) {
      if (event.snapshot.value == null || !event.snapshot.exists) {
        return;
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      data.forEach((key, value) async {
        final userData = Map<String, dynamic>.from(value);
        final matchingProfile = MatchingProfile.fromDocument(userData);

        if (matchingProfile.isIdel &&
            key != FirebaseAuth.instance.currentUser!.uid &&
            !isInChat.value) {
          if (isValidForMe(matchingProfile) &&
              isValidForOther(matchingProfile)) {
            log("Found valid match: $key");

            // Update both users' status atomically
            final updates = {
              "searching_users/$key/isIdel": false,
              "searching_users/$key/mateId":
                  profilePageController.userProfile.value?.uid ?? "",
              "searching_users/$key/inChat": true,
              "searching_users/${profilePageController.userProfile.value?.uid}/isIdel":
                  false,
              "searching_users/${profilePageController.userProfile.value?.uid}/mateId":
                  key,
              "searching_users/${profilePageController.userProfile.value?.uid}/inChat":
                  true,
            };

            await FirebaseDatabase.instance.ref().update(updates);
            isInChat.value = true;

            // Listen for mate's chat status
            _chatStatusSubscription = FirebaseDatabase.instance
                .ref("searching_users/$key/inChat")
                .onValue
                .listen((event) {
              if (event.snapshot.exists && event.snapshot.value == true) {
                if (!Get.isDialogOpen! && isInChat.value) {
                  Get.to(
                    () => TempChatPage(
                      users: [
                        key,
                        profilePageController.userProfile.value?.uid ?? ""
                      ],
                      timestamp: Timestamp.now(),
                      onExit: () {},
                    ),
                    transition: Transition.downToUp,
                  );
                }
              }
            });

            _roomSubscription = FirebaseDatabase.instance
                .ref("searching_users/$key")
                .onChildRemoved
                .listen((event) async {
              await removeMatchingData();
              Get.back();
              Get.to(
                () => ReviewProfilePage(uid: key),
                transition: Transition.downToUp,
              );
            });
          }
        }
      });
    });
  }

  void stopFindingMatch() async {
    await removeMatchingData().then((v) {
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      _chatStatusSubscription?.cancel();
      isMatching.value = false;
      isInChat.value = false;
    }).onError((err, stackTrace) {
      log(err.toString(), error: err, name: "error-stopFindingMatching");
      isMatching.value = true;
    });
  }

  bool isValidForMe(MatchingProfile data) {
    if (filterMaxAge > data.age && filterMinAge < data.age) {
      if (filterGender != "gender.both") {
        if (filterGender.toLowerCase() == data.gender.toLowerCase()) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  bool isValidForOther(MatchingProfile data) {
    final currentAge =
        _calculateAge(profilePageController.userProfile.value!.dob.toDate());
    if (data.filterMaxAge > currentAge && data.filterMinAge < currentAge) {
      if (data.filterGender != "gender.both") {
        if (data.filterGender.toLowerCase() ==
            profilePageController.userProfile.value!.gender.toLowerCase()) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  void onClose() {
    _matchSubscription?.cancel();
    _roomSubscription?.cancel();
    _chatStatusSubscription?.cancel();
    super.onClose();
  }
}
