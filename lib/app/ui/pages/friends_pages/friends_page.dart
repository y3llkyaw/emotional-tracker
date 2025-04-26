import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:emotion_tracker/app/ui/global_widgets/user_card.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/friends_request_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsController friendsController = Get.put(FriendsController());
  final OnlineController onlineController = Get.put(OnlineController());
  final TextEditingController searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    friendsController.getFriends();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              Text(
                "Friends",
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              const Icon(CupertinoIcons.person_3_fill)
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.75,
                    child: SearchWidget(
                      onSearch: (value) async {
                        setState(() {
                          searchBarController.text = value;
                        });
                      },
                      controller: searchBarController,
                      hintText: "Search for friends",
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (searchBarController.text == "") {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await Get.to(
                          () => FriendsRequestPage(),
                          transition: Transition.rightToLeft,
                        );
                        friendsController.getFriends();
                      } else {
                        setState(() {
                          searchBarController.text = "";
                        });
                      }
                    },
                    icon: searchBarController.text == ""
                        ? SizedBox(
                            width: Get.width * 0.04,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                const Icon(CupertinoIcons.person_fill),
                                Transform(
                                  transform: Matrix4.translationValues(
                                      Get.width * 0.02, 0, 0),
                                  child: Icon(
                                    CupertinoIcons.bell_fill,
                                    size: Get.width * 0.03,
                                  ),
                                ),
                                Transform(
                                  transform: Matrix4.translationValues(
                                      Get.width * 0.04, Get.height * 0.015, 0),
                                  child: Obx(
                                    () => friendsController.noFriReq != 0
                                        ? CircleAvatar(
                                            radius: Get.width * 0.02,
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.redAccent,
                                            child: Text(
                                              friendsController.noFriReq
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: Get.width * 0.02),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: Get.width * 0.04,
                            child: const Icon(CupertinoIcons.xmark),
                          ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.025),
              Center(
                child: Obx(
                  () {
                    final query = searchBarController.text.trim().toLowerCase();
                    final filteredFriends =
                        friendsController.friends.where((friend) {
                      if (query.isEmpty) return true;
                      return friend.name.toLowerCase().contains(query);
                    }).toList();

                    return SizedBox(
                      width: Get.width * 0.8,
                      child: Wrap(
                        spacing: Get.width * 0.08,
                        runSpacing: Get.width * 0.08,
                        children: <Widget>[
                          addFrinedCard(),
                          ...filteredFriends.map<Widget>((friend) {
                            onlineController.getFriendsOnlineStatus(friend.uid);
                            return InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await Get.to(
                                  () => OtherProfilePage(profile: friend),
                                  transition: Transition.downToUp,
                                );
                                friendsController.getFriends();
                              },
                              child: UserCard(profile: friend),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Get.width * 0.04),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget addFrinedCard() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      radius: 2000,
      splashColor: Colors.grey.shade400.withOpacity(0.5),
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await Get.toNamed('/add-friends');
        friendsController.getFriends();
      },
      child: Container(
        width: Get.width * 0.35,
        height: Get.width * 0.5,
        padding: EdgeInsets.symmetric(vertical: Get.width * 0.03),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: Get.width * 0.2,
              child: const CircleAvatar(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
            const Text(
              "Add New Friends",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }
}
