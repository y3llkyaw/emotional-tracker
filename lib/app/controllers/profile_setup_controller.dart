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

    if (!isProflieValid(name, gender, day, month, year)) {
      loading.value = false;
      return;
    }

    dob.value = DateTime(year.value, month.value, day.value);
    await auth.currentUser!.updateDisplayName(name.value);
    await firestore.collection("profile").doc(auth.currentUser!.uid).set({
      "uid": auth.currentUser!.uid,
      "name": name.value,
      "gender": gender.value.toString(),
      "dob": dob.value,
    }).then((value) {
      Get.snackbar("Success", "Profile setup successfully!");
      Get.offAllNamed("/home");
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
    loading.value = false;
    // await auth.currentUser!.updateProfile();
  }
}

bool isProflieValid(name, gender, day, month, year) {
  if (name.value.isEmpty) {
    return false;
  }
  if (gender.value == null) {
    return false;
  }
  if (day.value == null) {
    return false;
  }
  if (month.value == null) {
    return false;
  }
  if (year.value == null) {
    return false;
  }
  return true;
}
