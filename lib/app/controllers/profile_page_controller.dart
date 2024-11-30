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
}
