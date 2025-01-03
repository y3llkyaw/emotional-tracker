import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  var userProfile = Rxn<Profile>();
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getCurrentUserProfile();
  }

  Future<void> getCurrentUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    // await Future.delayed(const Duration(seconds: 5));
    return await FirebaseFirestore.instance
        .collection("profile")
        .doc(user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        final profile = value.data() as Map<String, dynamic>;
        userProfile.value = Profile.fromDocument(profile);
      }
    });
  }

  Future<void> updateDisplayName(String name) async {
    log("updateDisplayName called", name: "profile-page-controller");
    isLoading.value = true;
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name.trim());
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
