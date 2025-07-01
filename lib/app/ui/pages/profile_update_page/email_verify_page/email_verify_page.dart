import 'package:emotion_tracker/app/controllers/email_verify_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerifyPage extends StatelessWidget {
  EmailVerifyPage({Key? key}) : super(key: key);
  final emailverifyController = Get.put(EmailVerifyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Email Verification",
          style: TextStyle(
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: const Text(
                "Email Verification",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle:
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
              trailing: FirebaseAuth.instance.currentUser!.emailVerified
                  ? IconButton(
                      onPressed: () {
                        Get.snackbar(
                            "Verified", "Email already verified successfully!");
                      },
                      icon: const Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        Get.snackbar(
                            "Verify", "Send verification email to your email");
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        FirebaseAuth.instance.authStateChanges().listen((user) {
                          user!.reload();
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
          Obx(
            () => emailverifyController.isEmailVerified.value
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      text: "Email Verified",
                      onPressed: () {
                        Get.back();
                      },
                      color: Colors.green,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomButton(
                      text: "Resend Verification Email",
                      onPressed: () {
                        emailverifyController.sendVerificationEmail();
                      },
                      color: Colors.blue,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
