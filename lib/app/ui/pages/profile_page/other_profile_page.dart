import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/uid_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/chat_page/chat_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/widget/friend_piechart.dart';
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
  final uidController = Get.put(UidController());

  @override
  void initState() {
    super.initState();
    controller.friendStatusStream(widget.profile.uid);
  }

  final TextStyle textStyle = const TextStyle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
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
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: widget.profile.gender == "Gender.Female"
                            ? Colors.pink
                            : Colors.blue,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: "age",
                          child: Text(
                            "${DateTime.now().difference(widget.profile.dob.toDate()).inDays ~/ 365}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02),
                          width: Get.width * 0.005,
                          height: Get.height * 0.03,
                          color: Colors.grey,
                        ),
                        Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: widget.profile.gender == "Gender.Male"
                              ? "Male"
                              : widget.profile.gender == "Gender.Female"
                                  ? "Female"
                                  : "Other",
                          child: Icon(
                            widget.profile.gender == "Gender.Male"
                                ? Icons.male
                                : widget.profile.gender == "Gender.Female"
                                    ? Icons.female
                                    : CupertinoIcons.news,
                            color: widget.profile.gender == "Gender.Female"
                                ? Colors.pink
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    FutureBuilder(
                      future:
                          uidController.getUsernameByUid(widget.profile.uid),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'Loading...'
                              : snapshot.hasData
                                  ? "@${snapshot.data.toString()}"
                                  : widget.profile.uid,
                          style: TextStyle(
                            color: Get.theme.colorScheme.onSecondary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildFriendButton(widget.profile),
                    SizedBox(
                      width: Get.width * 0.9,
                      child: const Divider(
                        color: Colors.black12,
                      ),
                    ),
                    FriendPiechart(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildFriendButton(Profile profile) {
    return Obx(
      () {
        String buttonText = "Add friend";
        var buttonIcon = CupertinoIcons.person_add_solid;
        Color btnColor = Colors.blue;

        switch (controller.friendStatus.value) {
          case "friend":
            controller.fetchJournals(profile.uid.toString());
            buttonIcon = CupertinoIcons.person_crop_circle_fill_badge_checkmark;
            buttonText = "Friend";
            btnColor = Colors.grey;
            break;
          case "requested":
            buttonIcon = CupertinoIcons.clock_fill;
            buttonText = "requested";
            btnColor = Colors.grey;
            break;
          case "pending":
            buttonIcon = CupertinoIcons.clock_fill;
            buttonText = "pending";
            btnColor = Colors.blueAccent;
            break;
          case "blocked":
            buttonIcon = CupertinoIcons.person_crop_circle_badge_xmark;
            buttonText = "blocked";
            btnColor = Colors.redAccent;
            break;
          default:
        }

        void onClick() async {
          switch (controller.friendStatus.value) {
            case "friend":
              showUnfriend(profile);
              break;
            case "requested":
              showCancelRequest(profile);
              break;
            case "pending":
              showFriendAccept(profile);
              break;
            case "blocked":
              break;
            default:
              controller.addFriend(profile);
          }
        }

        ButtonStyle buttonStyle = ButtonStyle(
          backgroundColor: WidgetStateProperty.all(btnColor),
          iconColor: WidgetStateProperty.all(Colors.white),
        );

        return SizedBox(
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: buttonStyle,
                onPressed: onClick,
                label: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: Icon(
                  buttonIcon,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              controller.friendStatus.value == "friend"
                  ? ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.blueAccent,
                        ),
                      ),
                      onPressed: () {
                        final player = AudioPlayer();
                        player.play(AssetSource("audio/swoosh.mp3"));
                        Get.to(
                          () => ChatPage(
                            profile: profile,
                          ),
                          transition: Transition.rightToLeft,
                        );
                      },
                      label: const Text(
                        "Message",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
