import 'package:animated_rating_bar/animated_rating_bar.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
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
              "rate this person",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            AnimatedRatingBar(
              activeFillColor: Get.theme.colorScheme.error,
              initialRating: 3,
              onRatingUpdate: (rating) {},
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            TextField(
              maxLength: 100,
              onChanged: (text) {
                setState(() {
                  _reviewTxtController.text = text;
                });
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
              height: Get.height * 0.04,
            ),
            Column(
              children: [
                CustomButton(
                  text: "Skip",
                  color:
                      const Color.fromARGB(255, 128, 128, 128).withOpacity(0.5),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                CustomButton(
                  color: Get.theme.colorScheme.error,
                  isDisabled: _reviewTxtController.text.isEmpty,
                  text: "Review",
                  onPressed: () {},
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
