import 'package:emotion_tracker/app/controllers/auth_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:emotion_tracker/app/ui/global_widgets/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login ',
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
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                child: SvgPicture.asset(
                    "assets/image/undraw_mobile-login_4ntr.svg"),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              FormContainerWidget(
                hintText: 'Email Address',
                controller: emailController,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              FormContainerWidget(
                hintText: 'Password',
                isPasswordField: true,
                controller: passwordController,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Obx(
                () => CustomButton(
                  text: 'Log In',
                  isLoading: authController.isLoading.value,
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please enter email and password',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    if (!emailController.text.isEmail) {
                      Get.snackbar(
                        'Error',
                        'Please enter a valid email',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    await authController.signInWithEmail(
                      emailController.text,
                      passwordController.text,
                    );
                  },
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width / 2.8,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                  const Text('or'),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              OutlineButtonWidget(
                asset: "assets/image/google.svg",
                text: "Sign Up with Google",
                onPressed: () async {
                  authController.signInWithGoogle();
                },
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              OutlineButtonWidget(
                text: "Register with Email",
                onPressed: () {
                  Get.toNamed("/register/email");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
