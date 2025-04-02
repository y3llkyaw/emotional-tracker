import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:emotion_tracker/app/ui/global_widgets/user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsPage extends StatelessWidget {
  FriendsPage({Key? key}) : super(key: key);

  final FriendsController friendsController = Get.put(FriendsController());
  final OnlineController onlineController = Get.put(OnlineController());
  @override
  Widget build(BuildContext context) {
    friendsController.getFriends();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, // Ensure the background color remains the same
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              const Text(
                "Friends",
                style: TextStyle(fontWeight: FontWeight.w600),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.75,
                    child: SearchWidget(
                      onSearch: (value) async {
                        // addFriendsController.searchFriends(value);
                      },
                      controller: TextEditingController(),
                      hintText: "Search for friends",
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed('/add-friends');
                    },
                    icon: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const Icon(CupertinoIcons.person_fill),
                        Transform(
                          transform:
                              Matrix4.translationValues(Get.width * 0.02, 0, 0),
                          child: const Icon(
                            CupertinoIcons.bell_fill,
                            size: 15,
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
                                      friendsController.noFriReq.toString(),
                                      style:
                                          TextStyle(fontSize: Get.width * 0.02),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.025,
              ),
              Center(
                child: Obx(
                  () {
                    return SizedBox(
                      width: Get.width * 0.8,
                      child: Wrap(
                        spacing: Get.width * 0.08,
                        runSpacing: Get.width * 0.08,
                        children: <Widget>[addFrinedCard()] +
                            friendsController.friends.map<Widget>((friend) {
                              onlineController
                                  .getFriendsOnlineStatus(friend.uid);
                              return UserCard(profile: friend);
                            }).toList(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: Get.width * 0.04,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addFrinedCard() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      radius: 2000,
      splashColor: Colors.grey.shade400.withOpacity(0.5),
      onTap: () {
        Get.toNamed('/add-friends');
      },
      child: Container(
        width: Get.width * 0.35,
        height: Get.width * 0.5,
        padding: EdgeInsets.symmetric(
          vertical: Get.width * 0.03,
        ),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          // color: Get.theme.canvasColor, // Background color
          borderRadius: BorderRadius.circular(24.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: const Offset(0, 0), // Offset
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: Get.width * 0.2,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
            const Text(
              "Add New Friends",
              style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
