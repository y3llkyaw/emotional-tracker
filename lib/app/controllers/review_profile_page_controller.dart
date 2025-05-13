import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewProfilePageController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  Future<void> giveReview(String uid, String review) async {
    isLoading.value = true;
    await FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .collection("reviews")
        .add({
      "review": "This is a review",
      "createdAt": DateTime.now(),
    }).then((value) {
      Get.snackbar("Success", "Review added successfully");
    }).catchError((error) {
      Get.snackbar("Error", "Failed to add review: $error");
    }).then((v) {
      isLoading.value = false;
    });
  }
}
