import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/add_friends_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              controller: TextEditingController(),
              onSearch: (value) async {
                addFriendsController.searchFriends(value);
              },
              hintText: 'Search for friends',
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Obx(
              () => SizedBox(
                height: Get.height * 0.7,
                child: ListView.builder(
                  itemCount: addFriendsController.searchResults.length,
                  itemBuilder: (context, index) {
                    final profile = addFriendsController.searchResults[index];
                    return InkWell(
                      onTap: () => {},
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Get.width * 0.03,
                          horizontal: Get.width * 0.03,
                        ),
                        leading: CircleAvatar(
                          radius: 40,
                          child: AvatarPlus(
                            "${profile.uid.toString()}${profile.name}",
                          ),
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
                          icon: const Icon(Icons.person_add),
                          onPressed: () {
                            addFriendsController.addFriend(profile);
                          },
                        ),
                        subtitle: const Text("bio"),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
