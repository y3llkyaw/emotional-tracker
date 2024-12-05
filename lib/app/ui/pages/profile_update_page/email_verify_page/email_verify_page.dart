import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerifyPage extends StatelessWidget {
  const EmailVerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 16),
          //   child: const TextField(
          //     decoration: InputDecoration(
          //       labelText: "Email",
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
