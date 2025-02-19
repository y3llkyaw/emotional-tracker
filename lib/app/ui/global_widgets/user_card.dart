import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/friend_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  UserCard({Key? key, required this.profile}) : super(key: key);
  final Profile? profile;
  final OnlineController onlineController = Get.put(OnlineController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (profile != null) {
          Get.to(
            () => FriendProfilePage(
              profile: profile!,
            ),
            transition: Transition.downToUp,
          );
        }
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: Get.width * 0.35,
        height: Get.width * 0.5,
        padding: EdgeInsets.symmetric(
          vertical: Get.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white70,
          // color: Get.theme.canvasColor, // Background color
          borderRadius: BorderRadius.circular(24.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 4, // Spread radius
              blurRadius: 8, // Blur radius
              offset: const Offset(0, 0), // Offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Get.width * 0.07,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: Get.width * 0.2,
                  child: AvatarPlus(
                    "${profile!.uid.toString()}${profile!.name}",
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(40, -60, 0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: profile!.emoji != null
                        ? AnimatedEmoji(profile!.emoji!)
                        : const Text(""),
                  ),
                )
              ],
            ),
            Text(
              profile!.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: Get.width * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(),
            Text(
              timeago
                  .format(onlineController.lastSeem.value.toDate())
                  .toString(),
              style: TextStyle(
                fontSize: Get.width * 0.02,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
