import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/friend_profile_page.dart';
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
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: SearchWidget(
              controller: textController,
              onSearch: (value) async {
                addFriendsController.searchFriendsWithName(value);
              },
              hintText: 'Search for New friends',
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
    return FutureBuilder(
      future: addFriendsController.checkFriendStatus(profile),
      builder: (context, snapshot) {
        print(snapshot.data);
        var icon = const Icon(
          CupertinoIcons.person_crop_circle_badge_plus,
          color: Colors.blue,
        );
        String statusText = "click button to send request";
        Function action = () {
          setState(() {});
        };
        switch (snapshot.data) {
          case "FriendStatus.pending":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_minus,
              color: Colors.orangeAccent,
            );
            statusText = "click button to remove request";
            action = () async {
              _handleFriendStatusAction(
                snapshot.data as String?,
                profile,
              );
              await Get.to(() => OtherProfilePage(profile: profile));
              setState(() {});
            };
            break;
          case "FriendStatus.friend":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_checkmark,
              color: Colors.green,
            );
            statusText = "already friend";
            action = () async {
              await Get.to(() => FriendProfilePage(profile: profile));
              setState(() {});
            };
            break;
          case "FriendStatus.blocked":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_xmark,
              color: Colors.red,
            );
            statusText = "you blocked this person";
            action = () {};
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
                _handleFriendStatusAction(snapshot.data as String?, profile);
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

  void _handleFriendStatusAction(String? status, profile) {
    switch (status) {
      case "FriendStatus.none":
        addFriendsController.addFriend(profile).then((value) {
          setState(() {});
        });
        break;
      case "FriendStatus.pending":
        addFriendsController.removeFriendRequest(profile).then((value) {
          setState(() {});
        });
        break;
      default:
    }
  }
}
