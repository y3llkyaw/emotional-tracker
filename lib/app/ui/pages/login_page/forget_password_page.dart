import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forget Password',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                child:
                    SvgPicture.asset("assets/image/undraw_forgot-password.svg"),
              ),
              SizedBox(height: Get.height * 0.05),
              const Text(
                "Reset Your Account Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Enter your email address to reset your password.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: Get.height * 0.025),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'abcd@gmail.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: Get.height * 0.025),
              CustomButton(
                  text: "Send Reset Passowrd Link",
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    )
                        .then((value) async {
                      Get.snackbar(
                        "Success",
                        "Password reset link sent to ${emailController.text.trim()}",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                        colorText: Colors.white,
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      Get.back();
                    }).catchError((error) {
                      Get.snackbar(
                        "Error",
                        error.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    });
                  }),
              SizedBox(height: Get.height * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}
