import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ProfilePageController profilePageController = Get.find();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const ListTile(
              leading: Icon(Icons.lock, color: Colors.blueAccent),
              title: Text(
                "Change Your Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text("make sure none is looking at your screen"),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                obscureText: true,
                controller: currentPasswordController,
                decoration: const InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                obscureText: true,
                controller: newPasswordController,
                decoration: const InputDecoration(
                    label: Text("New Password"), border: OutlineInputBorder()),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                onChanged: (value) {},
                obscureText: true,
                controller: confirmNewPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm New Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Obx(
              () => CustomButton(
                isLoading: profilePageController.isLoading.value,
                isDisabled: profilePageController.isLoading.value,
                text: "Change Password",
                onPressed: () {
                  profilePageController.updatePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
