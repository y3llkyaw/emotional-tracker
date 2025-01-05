import 'package:emotion_tracker/app/controllers/add_friends_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsPage extends StatelessWidget {
  FriendsPage({Key? key}) : super(key: key);

  final AddFriendsController addFriendsController =
      Get.put(AddFriendsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Friends',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Get.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Get.height * 0.025,
              ),
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
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.025,
              ),
              Center(
                child: Wrap(
                  spacing: Get.width * 0.08,
                  runSpacing: Get.width * 0.08,
                  children: const [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
