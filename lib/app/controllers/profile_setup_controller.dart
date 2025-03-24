import 'dart:developer';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get.dart';

class ProfileSetupController extends GetxController {
  final RxBool loading = false.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var name = "".obs;
  var gender = Gender.Male.obs;
  var day = DateTime.now().day.obs;
  var month = DateTime.now().month.obs;
  var year = (DateTime.now().year - 18).obs;
  var dob = DateTime(DateTime.now().year - 18).obs;

  Future<void> setupProfile() async {
    loading.value = true;

    if (!isProfileValid()) {
      loading.value = false;
      Get.snackbar("Error", "Please fill all the required fields.");
      return;
    }

    dob.value = DateTime(year.value, month.value, day.value);

    try {
      await auth.currentUser?.updateDisplayName(name.value);

      await firestore.collection("profile").doc(auth.currentUser?.uid).set({
        "uid": auth.currentUser?.uid,
        "name": name.value,
        "name_lowercase": name.value.toLowerCase(),
        "gender": gender.value.toString(),
        "dob": dob.value.toIso8601String(),
        "recentEmojis": [
          AnimatedEmojis.angry.id,
          AnimatedEmojis.sad.id,
          AnimatedEmojis.neutralFace.id,
          AnimatedEmojis.smile.id,
          AnimatedEmojis.joy.id,
        ],
      });

      Get.snackbar("Success", "Profile setup successfully!");
      Get.offAllNamed("/home");
    } catch (error, stackTrace) {
      log("Error setting up profile: $error", stackTrace: stackTrace);
      Get.snackbar("Error", "Failed to setup profile. Please try again.");
    } finally {
      loading.value = false;
    }
  }

  bool isProfileValid() {
    if (name.value.isEmpty) return false;
    return true;
  }
}
