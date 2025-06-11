import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  UserCard({Key? key, required this.profile}) : super(key: key);
  final Profile? profile;
  final OnlineController onlineController = Get.put(OnlineController());
  final FriendsController friendsController = Get.put(FriendsController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.35,
      height: Get.height * 0.227,
      padding: EdgeInsets.symmetric(
        vertical: Get.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
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
          const SizedBox(),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: Get.width * 0.2,
                child: AvatarPlus(
                  "${profile!.uid.toString()}${profile!.name}",
                ),
              ),
            ],
          ),
          Text(
            profile!.name,
            textAlign: TextAlign.center,
            style: TextStyle(color: profile!.color),
          ),
          Text(
            onlineController.isOnline.value
                ? "online"
                : timeago
                    .format(
                      onlineController.friendsOnlineStatus[profile!.uid] ??
                          Timestamp.now().toDate(),
                    )
                    .toString(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
