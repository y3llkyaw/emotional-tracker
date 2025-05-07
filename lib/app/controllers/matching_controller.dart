import 'dart:async';
import 'dart:developer';

import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/matching_profile.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchingController extends GetxController {
  final profilePageController = Get.put(ProfilePageController());
  final isMatching = false.obs;
  var cuid = "".obs;
  var cdob = DateTime.now().obs;
  var cgender = "gender.other".obs;

  final filterMinAge = 17.obs;
  final filterMaxAge = 45.obs;
  final filterGender = "gender.male".obs;

  StreamSubscription<DatabaseEvent>? _matchSubscription;
  // StreamSubscription<DatabaseEvent>? _roomSubscription;
  // StreamSubscription<DatabaseEvent>? _exitSubscription;

  @override
  void onInit() {
    super.onInit();
    profilePageController.getCurrentUserProfile().then((v) {
      cuid.value = profilePageController.userProfile.value!.uid;
      cdob.value = profilePageController.userProfile.value!.dob.toDate();
      cgender.value =
          profilePageController.userProfile.value!.gender.toLowerCase();
    });
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
    final age = _calculateAge(cdob.value);
    final ref = FirebaseDatabase.instance.ref("searching_users/$cuid");
    await ref
        .set({
          "age": age,
          "gender": cgender.value,
          "filterMinAge": filterMinAge.value,
          "filterMaxAge": filterMaxAge.value,
          "filterGender": filterGender.value,
          "isIdel": true,
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
    final ref = FirebaseDatabase.instance.ref("searching_users/$cuid");
    await ref.remove().then((v) {
      isMatching.value = false;
      _matchSubscription?.cancel();
    }).onError((e, stackTrace) {
      log(e.toString(), error: e, name: "error-removing-matching-data");
      isMatching.value = true;
      _matchSubscription?.cancel();
    });
  }

  // Future<void> setRoomData(String uid) async {
  //   final user = [cuid.value, uid]..sort();
  //   final roomId = "${user[0]}_${user[1]}";
  //   final ref = FirebaseDatabase.instance.ref("rooms/$roomId");
  //   await ref.set({
  //     "users": user,
  //     "timestamp": Timestamp.now(),
  //   }).onError((e, stackTrace) {
  //     log(e.toString(), error: e, name: "error-setting-room-data");
  //   }).then((v) {
  //     isMatching.value = true;
  //   });
  //   // ref.onDisconnect().remove();
  // }

  // Future<void> removeRoomData(String roomId) async {
  //   final ref = FirebaseDatabase.instance.ref("rooms/$roomId");
  //   await ref.remove().then((v) {
  //     isMatching.value = false;
  //     _matchSubscription?.cancel();
  //   }).onError((e, stackTrace) {
  //     log(e.toString(), error: e, name: "error-removing-matching-data");
  //     isMatching.value = true;
  //     _roomSubscription?.cancel();
  //   });
  // }

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

      // Loop through each user's data
      data.forEach((key, value) async {
        final userData = Map<String, dynamic>.from(value);
        final matchingProfile = MatchingProfile.fromDocument(userData);
        if (matchingProfile.isIdel) {
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
              "mateId": cuid.value,
            });
            final myRef =
                FirebaseDatabase.instance.ref("searching_users/${cuid.value}");
            myRef.update({
              "isIdel": false,
              "mateId": cuid.value,
            });

            _matchSubscription?.cancel();
          }
        }
      });
    });
  }

  void startListeningRoom() {}

  void stopFindingMatch() async {
    await removeMatchingData().then((v) {
      _matchSubscription?.cancel();
      isMatching.value = false;
    }).onError((err, stackTrace) {
      log(err.toString(), error: err, name: "error-stopFindingMatching");
      isMatching.value = true;
    });
  }

  bool isValidForMe(MatchingProfile data) {
    log(data.toString(), name: "null-check-valid");
    if (filterMaxAge > data.age && filterMinAge < data.age) {
      log("\t[*]other person meet your req in age");
      if (filterGender != "gender.other") {
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

    final currentAge = _calculateAge(cdob.value);
    if (data.filterMaxAge > currentAge && data.filterMinAge < currentAge) {
      log("other person meet your req in age");
      if (data.filterGender != "gender.other") {
        if (data.filterGender.toLowerCase() == cgender.toLowerCase()) {
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
