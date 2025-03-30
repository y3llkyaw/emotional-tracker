import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/widget/profile_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final controller = Get.put(OtherProfilePageController());

  @override
  void initState() {
    super.initState();
    controller.checkFriendStatus(widget.profile);
  }

  final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.blue),
  );

  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
  );

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
              AnimatedContainer(
                duration: Durations.short1,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: Get.width * 0.4,
                        child: AvatarPlus(
                          "${widget.profile.uid.toString()}${widget.profile.name}",
                        ),
                      ),
                      Text(
                        widget.profile.name,
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
                            "${DateTime.now().difference(widget.profile.dob.toDate()).inDays ~/ 365}",
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
                            widget.profile.gender == Gender.Male
                                ? Icons.male
                                : widget.profile.gender == Gender.Female
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
                          _buildFriendButton(),
                          SizedBox(
                            width: Get.width * 0.04,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendButton() {
    return AnimatedContainer(
      duration: Durations.short1,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const ElevatedButton(
            onPressed: null,
            child: Text("Loading..."),
          );
        }
        final status = controller.friendStatus.value;
        switch (status) {
          case "FriendStatus.pending":
            return ElevatedButton.icon(
              onPressed: () => showPendingProfileBottomSheet(
                Get.context!,
                widget.profile,
              ),
              icon: const Icon(CupertinoIcons.clock),
              label: const Text("Pending"),
              style: _buttonStyle(Colors.orange),
            );
          case "FriendStatus.fr":
            return ElevatedButton.icon(
              onPressed: () =>
                  showRequestedProfileBottomSheet(Get.context!, widget.profile),
              icon: const Icon(Icons.person_outline),
              label: const Text("requested"),
              style: _buttonStyle(Colors.blue),
            );
          case "FriendStatus.friend":
            return Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => {
                    // showProfileFriendBottomSheet(
                    //   Get.context!,
                    //   widget.profile,
                    // ),
                    showProfileFriendBottomSheet()
                  },
                  icon: const Icon(
                      CupertinoIcons.person_crop_circle_badge_checkmark),
                  label: const Text("Friend"),
                  style: _buttonStyle(Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: const Icon(CupertinoIcons.chat_bubble_fill),
                  label: const Text("Message"),
                  style: _buttonStyle(Colors.blue),
                ),
              ],
            );
          case "FriendStatus.none":
            return ElevatedButton.icon(
              onPressed: () => controller.addFriend(widget.profile),
              icon: const Icon(CupertinoIcons.person_crop_circle_badge_plus),
              label: const Text("Add Friend"),
              style: _buttonStyle(Colors.blue),
            );
          default:
            return const ElevatedButton(
              onPressed: null,
              child: Text("Loading...."),
            );
        }
      }),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(color),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    );
  }
}
