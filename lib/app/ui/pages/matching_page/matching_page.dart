import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchingPage extends StatelessWidget {
  MatchingPage({Key? key}) : super(key: key);
  final matchingController = Get.put(MatchingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: Get.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              const Center(
                child: AnimatedEmoji(
                  AnimatedEmojis.eyes,
                  size: 100,
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Center(
                child: Text(
                  "The Eyes is finding for your matches.",
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.2,
                  aspectRatio: 2.0,
                  initialPage: 2,
                  autoPlayInterval: const Duration(milliseconds: 500),
                ),
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AvatarPlus('text $i'),
                      );
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              CustomButton(
                color: Get.theme.colorScheme.error,
                text: "Keep Finding",
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              CustomButton(
                color: Colors.red.shade600,
                text: "Quit Finding Your Matches",
                onPressed: () async {
                  matchingController.stopFindingMatch();
                  Get.back();
                },
              ),
              SizedBox(
                height: Get.height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
