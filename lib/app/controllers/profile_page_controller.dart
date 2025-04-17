import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  final JournalController journalController = JournalController();

  var userProfile = Rxn<Profile>();
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getCurrentUserProfile();
  }

  List<String> newEmojiList() {
    final original = userProfile.value!.recentEmojis.map((e) => e.id).toList();
    if (!original.contains(journalController.emotion.value.id)) {
      List<String> newEmoji = original + [journalController.emotion.value.id];
      newEmoji.removeAt(0);
      return newEmoji;
    }
    return original;
  }

  Future<void> updateRecentEmojis() async {
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "recentEmojis": newEmojiList(),
    }).then(
      (value) {},
    );
  }

  Future<Profile> getProfileByUid(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection("profile").doc(uid).get();
      if (doc.exists) {
        final profile = doc.data() as Map<String, dynamic>;
        return Profile.fromDocument(profile);
      } else {
        return Profile(
          uid: "",
          name: "",
          nameLowerCase: "",
          gender: Gender.Others,
          dob: Timestamp.now(),
          recentEmojis: [],
        );
      }
    } catch (e) {
      log("Error fetching profile: $e", name: "profile-page-controller");
      rethrow;
    }
  }

  Future<void> getCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      // await Future.delayed(const Duration(seconds: 5));
      return await FirebaseFirestore.instance
          .collection("profile")
          .doc(user!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          final profile = value.data() as Map<String, dynamic>;

          log(profile.toString(), name: "profile-page-controller-log");
          userProfile.value = Profile.fromDocument(profile);
        } else {
          Get.toNamed("profile/name");
        }
      });
    } catch (e) {
      log(e.toString(), name: "profile-page-controller-error");
    }
  }

  Future<void> updateDisplayName(String name) async {
    log("updateDisplayName called", name: "profile-page-controller");
    isLoading.value = true;
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(name.trim())
        .onError((e, s) {
      isLoading.value = false;
      Get.back();
      Get.snackbar("Error", e.toString());
    });
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("profile")
        .doc(user!.uid)
        .update({"name": user.displayName}).then(
      (value) async {
        await getCurrentUserProfile();
        isLoading.value = false;
        Get.back();
        Get.snackbar("Success", "Name updated successfully!");
      },
    ).onError((error, stackTrace) {
      isLoading.value = false;
      Get.back();
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> updateBsirthday(DateTime date) async {
    log("updating birthday", name: "profile-page-controller");
    isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(user!.uid)
        .update(
      {
        "dob": date.toIso8601String(),
      },
    ).then(
      (value) async {
        await getCurrentUserProfile().then((v) {
          isLoading.value = false;
          Get.back();
          Get.snackbar("Success", "Birthday updated successfully!");
        });
      },
    ).onError((error, stackTrace) {
      isLoading.value = false;
      Get.back();
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> updateBirthday(DateTime date) async {
    log("Birthday Updating", name: "profile-page-controller");
    isLoading.value = true;
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(user!.uid)
        .update({
      "dob": date.toIso8601String(),
    }).then(
      (value) async {
        await getCurrentUserProfile();
        isLoading.value = false;
        Get.back();
        Get.snackbar("Success", "Birthday updated successfully!");
      },
    ).onError((error, stackTrace) {
      isLoading.value = false;
      Get.back();
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> updatePassword(String password, String newPassword) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: password,
      );
      await FirebaseAuth.instance.currentUser!
          .updatePassword(newPassword)
          .then((value) async {
        isLoading.value = false;
        Get.back();
        Get.snackbar("Success", "Password updated successfully!");
      });
    } catch (e) {
      isLoading.value = false;
      Get.back();
      Get.snackbar("Error", e.toString());
      return;
    }
  }
}
