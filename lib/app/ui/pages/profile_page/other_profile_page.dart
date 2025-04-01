import 'dart:developer';

import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
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
                        children: [
                          FutureBuilder(
                              future:
                                  controller.checkFriendStatus(widget.profile),
                              builder: (context, snapshot) {
                                log(snapshot.data.toString(),
                                    name: "other-profile-page");
                                return Container(
                                  child: Text(controller.journals.toString()),
                                );
                              })
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

  ButtonStyle _buttonStyle(Color color) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(color),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    );
  }
}
