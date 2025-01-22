import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:get/get.dart';

void showPendingProfileBottomSheet(BuildContext context, Profile profile) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ProfileBottomSheet(profile: profile),
  );
}

void showRequestedProfileBottomSheet(BuildContext context, Profile profile) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ProfileRequestedBottomSheet(profile: profile),
  );
}

void showProfileFriendBottomSheet(BuildContext context, Profile profile) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ProfileFriendBottomSheet(profile: profile),
  );
}

class ProfileBottomSheet extends StatelessWidget {
  final Profile profile;

  const ProfileBottomSheet({Key? key, required this.profile}) : super(key: key);

  OtherProfilePageController get controller =>
      Get.find<OtherProfilePageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
        child: Column(
          children: [
            // AvatarPlus("${profile.uid}${profile.name}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                )
              ],
            ),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.height * 0.2,
              child: const AnimatedEmoji(AnimatedEmojis.crystalBall),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "waiting ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: profile.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const TextSpan(
                    text: " to be approved",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(children: [
                const TextSpan(
                  text: "Do you want to ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "remove",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text: " friend request ?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => controller.isLoading.value
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: null,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                          ),
                          onPressed: () async {
                            await controller
                                .removeFriendRequest(profile)
                                .then((v) {
                              Get.back();
                            });
                          },
                          label: const Text("Remove Friend-request",
                              style: TextStyle(color: Colors.white)),
                          icon: const Icon(
                            CupertinoIcons.person_crop_circle_badge_minus,
                            color: Colors.white,
                          ),
                        ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  label: const Text("close",
                      style: TextStyle(color: Colors.white)),
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ); // Add your bottom sheet content here
  }
}

class ProfileRequestedBottomSheet extends StatelessWidget {
  final Profile profile;

  const ProfileRequestedBottomSheet({Key? key, required this.profile})
      : super(key: key);

  OtherProfilePageController get controller =>
      Get.find<OtherProfilePageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
        child: Column(
          children: [
            // AvatarPlus("${profile.uid}${profile.name}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                )
              ],
            ),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.height * 0.2,
              child: const AnimatedEmoji(AnimatedEmojis.crystalBall),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: profile.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const TextSpan(
                    text: " is waiting ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: "to be approved",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(children: [
                const TextSpan(
                  text: "Do you want to ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "Accept",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const TextSpan(
                  text: " friend request ?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => controller.isLoading.value
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                          ),
                          onPressed: null,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                          ),
                          onPressed: () async {
                            await controller.confirmRequest(profile).then((v) {
                              Get.back();
                            });
                          },
                          label: const Text("Accept",
                              style: TextStyle(color: Colors.white)),
                          icon: const Icon(
                            CupertinoIcons.person_crop_circle_badge_checkmark,
                            color: Colors.white,
                          ),
                        ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () async {
                    await controller.removeFriendRequest(profile).then((v) {
                      Get.back();
                    });
                  },
                  label: const Text("Decline",
                      style: TextStyle(color: Colors.white)),
                  icon: const Icon(
                    CupertinoIcons.person_badge_minus_fill,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ); // Add your bottom sheet content here
  }
}

class ProfileFriendBottomSheet extends StatelessWidget {
  final Profile profile;

  const ProfileFriendBottomSheet({Key? key, required this.profile})
      : super(key: key);

  OtherProfilePageController get controller =>
      Get.find<OtherProfilePageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
        child: Column(
          children: [
            // AvatarPlus("${profile.uid}${profile.name}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                )
              ],
            ),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.height * 0.2,
              child: const AnimatedEmoji(AnimatedEmojis.crystalBall),
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "waiting ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: profile.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const TextSpan(
                    text: " to be approved",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(children: [
                const TextSpan(
                  text: "Do you want to ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: "remove",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                const TextSpan(
                  text: " friend request ?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => controller.isLoading.value
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: null,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1,
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                          ),
                          onPressed: () async {
                            await controller
                                .removeFriendRequest(profile)
                                .then((v) {
                              Get.back();
                            });
                          },
                          label: const Text("Remove Friend-request",
                              style: TextStyle(color: Colors.white)),
                          icon: const Icon(
                            CupertinoIcons.person_crop_circle_badge_minus,
                            color: Colors.white,
                          ),
                        ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  label: const Text("close",
                      style: TextStyle(color: Colors.white)),
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ); // Add your bottom sheet content here
  }
}
