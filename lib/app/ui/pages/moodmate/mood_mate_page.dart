import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/create_post_page/create_post_page.dart';
import 'package:emotion_tracker/app/ui/pages/posts_page.dart/post_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodMatePage extends StatelessWidget {
  MoodMatePage({Key? key}) : super(key: key);
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());

  final MatchingController matchingController = Get.put(MatchingController());
  final onlineController = Get.put(OnlineController());

  @override
  Widget build(BuildContext context) {
    // profilePageController.getCurrentUserProfile();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              Text(
                "MoodMate",
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              const Icon(CupertinoIcons.heart_fill)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                showDatingFilterSheet();
              },
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.transparent,
              child: Card(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error,
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 0), // Offset
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(Get.width * 0.005),
                  width: Get.width * 0.8,
                  height: Get.height * 0.1,
                  // color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Get.width * 0.2,
                        child: SvgPicture.asset("assets/icons/logo.svg"),
                      ),
                      SizedBox(
                        width: Get.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Find your moodmate",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Online Users -",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.02,
                                ),
                                FutureBuilder(
                                    future:
                                        onlineController.getOnlineUserCount(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.aBeeZee(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: PostPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Get.to(
            () => const CreatePostPage(),
            transition: Transition.downToUp,
          );
        },
        backgroundColor: Get.theme.colorScheme.error,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
