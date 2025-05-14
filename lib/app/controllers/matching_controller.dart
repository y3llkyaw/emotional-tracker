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

  final filterMinAge = 17.obs;
  final filterMaxAge = 45.obs;
  final filterGender = "gender.male".obs;

  StreamSubscription<DatabaseEvent>? _matchSubscription;
  StreamSubscription<DatabaseEvent>? _roomSubscription;
  // StreamSubscription<DatabaseEvent>? _exitSubscription;

  @override
  void onInit() async {
    super.onInit();
    await profilePageController.getCurrentUserProfile();
    log("🔧 MatchingController initialized");
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    // Check if the birthday has occurred this year
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
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      log("Removed matching data");
    }).onError((e, stackTrace) {
      log(e.toString(), error: e, name: "error-removing-matching-data");
      isMatching.value = true;
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      log("Error removing matching data");
      log(e.toString(), error: e, name: "error-removing-matching-data");
      Get.snackbar("", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true);
    });
    _matchSubscription?.cancel();
    _roomSubscription?.cancel();
  }

  void findingMatchPerson() async {
    await setMatchingData();
    final listRef = FirebaseDatabase.instance.ref("searching_users");
    log("Listening for matching users");
    _matchSubscription = listRef.onValue.listen((event) {
      log("Snapshot: ${event.snapshot}", name: "null-check");
      log("Snapshot value: ${event.snapshot.value}", name: "null-check");

      if (event.snapshot.value == null || !event.snapshot.exists) {
        return;
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final room = FirebaseDatabase.instance.ref(
          "searching_users/${profilePageController.userProfile.value?.uid ?? "log"}");
      room.onValue.listen((event) {
        print(event.snapshot.value);
        if (event.snapshot.value == null || !event.snapshot.exists) {
          return;
        }
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          final userData = Map<String, dynamic>.from(value);
          final matchingProfile = MatchingProfile.fromDocument(userData);
          if (matchingProfile.mateId != null) {
            Get.to(
              () => TempChatPage(
                users: [
                  matchingProfile.mateId ?? "hello",
                  profilePageController.userProfile.value?.uid ?? ""
                ],
                timestamp: Timestamp.now(),
                onExit: () {},
              ),
              transition: Transition.downToUp,
            );
            _matchSubscription?.cancel();
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
              _matchSubscription?.cancel();
              _roomSubscription?.cancel();
              isMatching.value = false;
              // print(event.snapshot.value);
            });
          }
        });
      }, onError: (error) {});
      // Loop through each user's data
      data.forEach((key, value) async {
        final userData = Map<String, dynamic>.from(value);
        final matchingProfile = MatchingProfile.fromDocument(userData);

        if (matchingProfile.isIdel &&
            key != FirebaseAuth.instance.currentUser!.uid) {
          log(
            isValidForMe(matchingProfile).toString(),
            name: "isValidForMe",
          );
          log(
            isValidForOther(matchingProfile).toString(),
            name: "isValidForOther",
          );
          if (isValidForMe(matchingProfile) &&
              isValidForOther(matchingProfile)) {
            log("Found valid match: $key");
            final mateRef =
                FirebaseDatabase.instance.ref("searching_users/$key");
            mateRef.update({
              "isIdel": false,
              "mateId": profilePageController.userProfile.value?.uid ?? "",
              "timestamp": ServerValue.timestamp,
            });
            final myRef = FirebaseDatabase.instance.ref(
                "searching_users/${profilePageController.userProfile.value?.uid ?? "log"}");
            myRef.update({
              "isIdel": false,
              "mateId": key,
              "timestamp": ServerValue.timestamp,
            });
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
            _matchSubscription?.cancel();
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
              _matchSubscription?.cancel();
              _roomSubscription?.cancel();
              isMatching.value = false;
              // print(event.snapshot.value);
            });
          }
        }
      });
    });
  }

  void startListeningRoom() {}

  void stopFindingMatch() async {
    await removeMatchingData().then((v) {
      _matchSubscription?.cancel();
      _roomSubscription?.cancel();
      isMatching.value = false;
    }).onError((err, stackTrace) {
      log(err.toString(), error: err, name: "error-stopFindingMatching");
      isMatching.value = true;
    });
  }

  bool isValidForMe(MatchingProfile data) {
    log(data.toString(), name: "null-check-valid");
    if (filterMaxAge > data.age && filterMinAge < data.age) {
      log("[*]other person meet your req in age");
      if (filterGender != "gender.both") {
        if (filterGender.toLowerCase() == data.gender.toLowerCase()) {
          log("other person meet your req in gender");
          return true;
        }
      } else {
        return true;
      }
    } else {
      log("other person doesn't meet your req in age");
    }
    return false;
  }

  bool isValidForOther(MatchingProfile data) {
    log(data.toString(), name: "null-check-valid");

    final currentAge =
        _calculateAge(profilePageController.userProfile.value!.dob.toDate());
    if (data.filterMaxAge > currentAge && data.filterMinAge < currentAge) {
      log("other person meet your req in age");
      if (data.filterGender != "gender.both") {
        if (data.filterGender.toLowerCase() ==
            profilePageController.userProfile.value!.gender.toLowerCase()) {
          log("other person meet your req in gender");
          return true;
        }
      } else {
        return true;
      }
    } else {
      log("other person doesn't meet your req in age");
    }
    return false;
  }

  @override
  void onClose() {
    _matchSubscription?.cancel();
    super.onClose();
  }
}
