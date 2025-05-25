import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewProfilePageController extends GetxController {
  final isLoading = false.obs;
  final reviewText = "".obs;
  final rating = 3.0.obs;

  Future<void> giveReview(String uid, String review) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .collection("reviews")
        .add({
      "rating": rating.value,
      "review": reviewText.value,
      "createdAt": DateTime.now(),
    }).then((value) {
      reviewText.value = "";
      isLoading.value = false;
      Get.back();
      Get.snackbar("Success", "Review added successfully");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to add review: $error");
    });
  }
}
