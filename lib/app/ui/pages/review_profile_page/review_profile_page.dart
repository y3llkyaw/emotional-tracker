// import 'package:animated_rating_bar/animated_rating_bar.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/review_profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';

class ReviewProfilePage extends StatefulWidget {
  const ReviewProfilePage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ReviewProfilePage> createState() => _ReviewProfilePageState();
}

class _ReviewProfilePageState extends State<ReviewProfilePage> {
  final TextEditingController _reviewTxtController = TextEditingController();
  final ProfilePageController profilePageController = ProfilePageController();
  final ReviewProfilePageController reviewProfilePageController =
      Get.put(ReviewProfilePageController());
  @override
  void dispose() {
    _reviewTxtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review This Person"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.08,
            ),
            FutureBuilder(
                future: profilePageController.getProfileByUid(widget.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData == false) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (snapshot.data == "") {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: Get.width * 0.3,
                        height: Get.width * 0.3,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final profile = snapshot.data as Profile;

                    return Center(
                      child: SizedBox(
                        width: Get.width * 0.3,
                        height: Get.width * 0.3,
                        child: AvatarPlus(
                          "${profile.uid}${profile.name}",
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: SizedBox(
                      width: Get.width * 0.3,
                      height: Get.width * 0.3,
                      child: CircularProgressIndicator(
                        color: Get.theme.colorScheme.error,
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: Get.height * 0.02,
            ),
            const Text(
              "Please provide your rating for this person",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Obx(
              () => Column(
                children: [
                  RatingStars(
                    value: reviewProfilePageController.rating.value,
                    onValueChanged: (value) {
                      // profilePageController.updateReviewText(value.toString());
                      reviewProfilePageController.rating.value = value;
                    },
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                      size: 30,
                    ),
                    starCount: 5,
                    starSize: 30,
                    valueLabelVisibility: false,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                        "${reviewProfilePageController.rating.toInt()} / 5"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            TextField(
              maxLength: 100,
              onChanged: (text) {
                // profilePageController.updateReviewText(text);
                reviewProfilePageController.reviewText.value = text;
              },
              controller: _reviewTxtController,
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Get.theme.colorScheme.error,
                  ),
                ),
                hintText: "Write your review here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Obx(
              () => Column(
                children: [
                  CustomButton(
                    isLoading: reviewProfilePageController.isLoading.value,
                    // isDisabled: reviewProfilePageController.isLoading.value,
                    text: "Skip",
                    color: const Color.fromARGB(255, 128, 128, 128)
                        .withOpacity(0.5),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  CustomButton(
                    isLoading: reviewProfilePageController.isLoading.value,
                    color: Get.theme.colorScheme.error,
                    isDisabled: reviewProfilePageController.reviewText.value
                        .trim()
                        .isEmpty,
                    text: "Review",
                    onPressed: () async {
                      // print("object");
                      if (_reviewTxtController.text.isNotEmpty) {
                        await reviewProfilePageController.giveReview(
                            widget.uid, _reviewTxtController.text);
                      }
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
