import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: Get.width * 0.3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/image/undraw_metrics_02ml.svg',
                  height: 250,
                  width: 250,
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to',
                  ),
                  Text(
                    'MoodMate.',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: Get.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Track your mood and feelings.\n Share your moods with friends.\n Analyize your moods.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: CustomButton(
                  text: "LET'S FIND OUT",
                  isDisabled: false,
                  onPressed: () {
                    Get.toNamed("/login");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
