import 'package:emotion_tracker/app/ui/global_widgets/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Create an account",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  // height: 50,
                  child: SvgPicture.asset(
                    "assets/image/line.svg",
                  ),
                ),
              ],
            ),
            SvgPicture.asset("assets/image/undraw_sign-up_qamz.svg"),
            // Image.asset("assets/image/undraw_sign-up_qamz.svg"),
            const Text(
              " so I can help you to find out how are you feeling.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            OutlineButtonWidget(
              text: "Sign up with Google",
              onPressed: () {},
              height: 60,
              asset: "assets/image/google.svg",
            ),
            OutlineButtonWidget(
              text: "Sign up with Facebook",
              onPressed: () {},
              height: 60,
              asset: "assets/image/facebook.svg",
            ),
            OutlineButtonWidget(
              text: "Sign up with Email",
              onPressed: () {
                Get.toNamed("/register/email");
              },
              height: 60,
              asset: "assets/image/email.svg",
            ),
            const SizedBox(),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
