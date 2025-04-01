import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:get/get.dart';

void showCancelRequest(Profile profile) {
  final FriendsController friendsController = FriendsController();
  showModalBottomSheet(
    context: Get.context!,
    builder: (context) {
      return Container(
        height: Get.height * 0.18,
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.02,
        ),
        child: Column(
          children: [
            ListTile(
              iconColor: Colors.redAccent,
              leading: const Icon(CupertinoIcons.person_badge_minus_fill),
              title: const Text(
                "remove friend request ",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                await friendsController.removeFriendRequest(profile).then((v) {
                  Get.back();
                });
              },
            ),
            // ListTile(
            //   leading: const Icon(
            //     CupertinoIcons.person_crop_circle_fill_badge_xmark,
            //     color: Colors.red,
            //   ),
            //   title: const Text(
            //     "Block this person",
            //     style: TextStyle(
            //       color: Colors.redAccent,
            //     ),
            //   ),
            //   onTap: () {
            //     Get.back();
            //   },
            // ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.xmark_circle,
                color: Colors.blue,
              ),
              title: const Text(
                "close",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    },
  );
}
