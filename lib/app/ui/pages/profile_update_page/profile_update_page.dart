import 'package:emotion_tracker/app/ui/pages/profile_update_page/change_password_page/change_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text =
        FirebaseAuth.instance.currentUser!.displayName.toString();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // name
            InkWell(
              onTap: () {},
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(Icons.person),
                title: const Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  color: Colors.black,
                  weight: 20,
                ),
              ),
            ),
            // Email
            InkWell(
              onTap: () {},
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(
                  CupertinoIcons.mail,
                ),
                title: const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  color: Colors.black,
                  weight: 20,
                ),
              ),
            ),

            // Password
            InkWell(
              onTap: () {
                Get.toNamed("profile/update/password");
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(
                  CupertinoIcons.lock,
                ),
                title: const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  "change your password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  color: Colors.black,
                  weight: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
