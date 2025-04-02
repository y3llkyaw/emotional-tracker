import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
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
            buttonIcon = CupertinoIcons.person_crop_circle_fill_badge_checkmark;
            buttonText = "friend";
            btnColor = Colors.blueAccent;
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
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz_sharp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
