import 'package:emotion_tracker/app/controllers/email_verify_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RegisterEmailVerifiedPage extends StatefulWidget {
  const RegisterEmailVerifiedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterEmailVerifiedPage> createState() =>
      _RegisterEmailVerifiedPageState();
}

class _RegisterEmailVerifiedPageState extends State<RegisterEmailVerifiedPage> {
  final emailVerificationController = Get.put(EmailVerifyController());
  @override
  void initState() {
    super.initState();
    emailVerificationController.sendVerificationEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification Process"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  height: Get.height * 0.3,
                  width: Get.width * 0.8,
                  child:
                      SvgPicture.asset("assets/image/undraw_email_verify.svg"),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                "A verification email has been sent to ${FirebaseAuth.instance.currentUser!.email}. Please check your inbox and click the verification link to complete the registration process.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Obx(() => CustomButton(
                    text: emailVerificationController.isEmailVerified.value
                        ? "Email Verified! Continue"
                        : emailVerificationController.resendCooldown.value > 0
                            ? "Resend Email Verification (${emailVerificationController.resendCooldown.value}s)"
                            : "Resend Email Verification",
                    onPressed: emailVerificationController.isEmailVerified.value
                        ? () {
                            Get.offAllNamed("/home");
                          }
                        : emailVerificationController.resendCooldown.value > 0
                            ? () {}
                            : () async {
                                await emailVerificationController
                                    .sendVerificationEmail();
                              },
                    isDisabled: emailVerificationController
                            .isEmailVerified.value
                        ? false
                        : emailVerificationController.resendCooldown.value > 0,
                  )),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shadowColor: Colors.transparent,
                  ),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.lock),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Get.offAllNamed("/landing_page");
                    });
                    // Implement sign out functionality here
                  },
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
