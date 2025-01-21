import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final fc = FriendsController();

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
              )
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
                          FutureBuilder(
                              future: fc.checkFriendStatus(widget.profile),
                              builder: (context, snapshot) {
                                // print("ekm ${snapshot.data}");
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ElevatedButton.icon(
                                    onPressed: () async {},
                                    label: const Text("loading"),
                                    icon: const Icon(CupertinoIcons.circle),
                                  );
                                } else if (snapshot.hasData) {
                                  if (snapshot.data! == "FriendStatus.fr") {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                await fc
                                                    .confirmFriendRequest(
                                                        widget.profile)
                                                    .then((v) {
                                                  setState(() {});
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Colors.blue,
                                                ),
                                              ),
                                              child: const Text(
                                                "Accept",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Colors.red.shade400,
                                                ),
                                              ),
                                              child: const Text(
                                                "Decline",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                  return ElevatedButton.icon(
                                    onPressed: () async {
                                      await fc
                                          .removeFriendRequest(widget.profile)
                                          .then((v) {
                                        setState(() {});
                                      });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Colors.orange),
                                    ),
                                    label: const Text(
                                      "  remove  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    icon: const Icon(
                                      CupertinoIcons
                                          .person_crop_circle_badge_minus,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return ElevatedButton.icon(
                                  onPressed: () async {
                                    await fc
                                        .addFriend(widget.profile)
                                        .then((v) {
                                      setState(() {});
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.blue),
                                  ),
                                  label: const Text(
                                    "add friend",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.person_badge_plus_fill,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.grey),
                            ),
                            label: const Text(
                              "More",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
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
}
