import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: CustomButton(
            text: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed("/home");
            },
          ),
        ),
      ),
    );
  }
}
