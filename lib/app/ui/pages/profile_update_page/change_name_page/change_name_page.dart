import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({Key? key}) : super(key: key);

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final ProfilePageController profilePageController = Get.find();
  String name = FirebaseAuth.instance.currentUser!.displayName.toString();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AvatarPlus(
              "${FirebaseAuth.instance.currentUser!.uid.toString()}${name.trim()}",
              width: Get.width * 0.5,
              height: Get.width * 0.5,
            ),
            const ListTile(
              title: Text(
                "Change Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle:
                  Text("try to match your name with your favourite Avatar."),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                maxLength: 70,
                onChanged: (value) {
                  setState(() {
                    name = value;
                    nameController.text = value;
                  });
                },
              ),
            ),
            Obx(
              () => CustomButton(
                isDisabled: profilePageController.isLoading.value,
                isLoading: profilePageController.isLoading.value,
                text: "Upate Name",
                onPressed: () {
                  profilePageController.updateDisplayName(name);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
