import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/add_friends_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsAddPage extends StatefulWidget {
  const FriendsAddPage({Key? key}) : super(key: key);

  @override
  State<FriendsAddPage> createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  final AddFriendsController addFriendsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              child: SearchWidget(
                controller: TextEditingController(),
                onSearch: (value) async {
                  addFriendsController.searchFriendsWithName(value);
                },
                hintText: 'Search for friends',
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(() => _buildSearchResults()),
          ],
        ),
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
    return InkWell(
      onTap: () => {},
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
        trailing: _buildFriendStatusIcon(profile),
        subtitle: _buildFriendStatusText(profile),
      ),
    );
  }

  Widget _buildFriendStatusIcon(profile) {
    return FutureBuilder(
      future: addFriendsController.checkFriendStatus(profile),
      builder: (context, snapshot) {
        var icon = const Icon(
          CupertinoIcons.person_crop_circle_badge_plus,
          color: Colors.blue,
        );

        switch (snapshot.data) {
          case "FriendStatus.pending":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_minus,
              color: Colors.orangeAccent,
            );
            break;
          case "FriendStatus.friend":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_checkmark,
              color: Colors.green,
            );
            break;
          case "FriendStatus.blocked":
            icon = const Icon(
              CupertinoIcons.person_crop_circle_badge_xmark,
              color: Colors.red,
            );
            break;
        }

        return IconButton(
          alignment: Alignment.centerRight,
          icon: icon,
          onPressed: () {
            _handleFriendStatusAction(snapshot.data as String?, profile);
          },
        );
      },
    );
  }

  Widget _buildFriendStatusText(profile) {
    return FutureBuilder(
      future: addFriendsController.checkFriendStatus(profile),
      builder: (context, snapshot) {
        String status = "click button to send request";
        switch (snapshot.data) {
          case "FriendStatus.pending":
            status = "click button to remove request";
            break;
          case "FriendStatus.friend":
            status = "already friend";
            break;
          case "FriendStatus.blocked":
            status = "you blocked this person";
            break;
        }
        return Text(
          status,
          style: const TextStyle(color: Colors.grey),
        );
      },
    );
  }

  void _handleFriendStatusAction(String? status, profile) {
    switch (status) {
      case null:
        addFriendsController.addFriend(profile).then((value) {
          setState(() {});
        });
        break;
      case "FriendStatus.pending":
        addFriendsController.removeFriendRequest(profile).then((value) {
          setState(() {});
        });
        break;
    }
  }
}
