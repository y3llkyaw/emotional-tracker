import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/add_friends_qr.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsAddPage extends StatefulWidget {
  const FriendsAddPage({Key? key}) : super(key: key);

  @override
  State<FriendsAddPage> createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  final FriendsController addFriendsController = Get.find();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    addFriendsController.searchFriendsWithName("");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,  
        title: const Text(
          'Add Friends',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.005),
            child: Row(
              children: [
                SizedBox(
                  width: Get.width * 0.8,
                  child: SearchWidget(
                    controller: textController,
                    onSearch: (value) async {
                      addFriendsController.searchFriendsWithName(value);
                    },
                    hintText: 'Search for New friends',
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.1,
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => QRScannerPage());
                    },
                    icon: Icon(
                      CupertinoIcons.qrcode_viewfinder,
                      size: Get.width * 0.08,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Obx(() => _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SizedBox(
      height: Get.height * 0.7,
      child: ListView.builder(
        itemCount: addFriendsController.searchResults.length,
        itemBuilder: (context, index) {
          final profile = addFriendsController.searchResults[index];
          return _buildFriendTile(profile);
        },
      ),
    );
  }

  Widget _buildFriendTile(profile) {
    return StreamBuilder(
      stream: addFriendsController.friendStatusStream(profile.uid),
      builder: (context, snapshot) {
        var icon = const Icon(
          CupertinoIcons.person_crop_circle_badge_plus,
          color: Colors.blue,
        );
        String statusText = "click button to send request";
        Function action = () async {
          await addFriendsController.addFriend(profile);
          setState(() {
            setState(() {});
          });
        };
        switch (snapshot.data) {
          case "requested":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_minus,
              color: Colors.orangeAccent,
            );
            statusText = "click button to remove request";
            action = () async {
              await Get.to(() => OtherProfilePage(profile: profile));
              setState(() {});
            };
            break;
          case "friend":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_checkmark,
              color: Colors.green,
            );
            statusText = "already friend";
            action = () async {
              await Get.to(() => OtherProfilePage(profile: profile));
              setState(() {});
            };
            break;
          default:
            action = () async {
              await Get.to(() => OtherProfilePage(profile: profile));
              setState(() {});
            };
        }
        return InkWell(
          onTap: () {
            action();
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              vertical: Get.width * 0.03,
              horizontal: Get.width * 0.03,
            ),
            leading: CircleAvatar(
              radius: 40,
              child: AvatarPlus("${profile.uid.toString()}${profile.name}"),
            ),
            title: Text(
              profile.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              alignment: Alignment.centerRight,
              icon: icon,
              onPressed: () {
                action;
                // _handleFriendStatusAction(snapshot.data as String?, profile);
              },
            ),
            subtitle: Text(
              statusText,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}
