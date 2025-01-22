import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/widget/profile_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendProfilePage extends StatelessWidget {
  FriendProfilePage({Key? key, required this.profile}) : super(key: key);
  final FriendsController fc = FriendsController();
  final controller = Get.put(OtherProfilePageController());

  final Profile profile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(CupertinoIcons.xmark),
              ),
              SizedBox(
                width: Get.width * 0.03,
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      child: AvatarPlus(
                        "${profile.uid.toString()}${profile.name}",
                      ),
                    ),
                    Text(
                      profile.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${DateTime.now().difference(profile.dob.toDate()).inDays ~/ 365}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02),
                          width: Get.width * 0.005,
                          height: Get.height * 0.03,
                          color: Colors.grey,
                        ),
                        Icon(
                          profile.gender == Gender.Male
                              ? Icons.male
                              : profile.gender == Gender.Female
                                  ? Icons.female
                                  : CupertinoIcons.news,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width * 0.1,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            showProfileFriendBottomSheet(
                              Get.context!,
                              profile,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.grey),
                          ),
                          label: const Text(
                            "Friend",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(
                            CupertinoIcons.person_crop_circle_badge_checkmark,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                          ),
                          label: const Text(
                            "Message",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(
                            CupertinoIcons.chat_bubble_fill,
                            color: Colors.white,
                          ),
                        ),
                        // SizedBox(
                        //   width: Get.width * 0.03,
                        // ),
                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   style: ButtonStyle(
                        //     backgroundColor:
                        //         WidgetStateProperty.all(Colors.grey),
                        //   ),
                        //   label: const Text(
                        //     "More",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        //   icon: const Icon(
                        //     Icons.more_horiz,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
