import 'package:emotion_tracker/app/controllers/auth_controller.dart';
import 'package:emotion_tracker/app/controllers/register_email_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({Key? key}) : super(key: key);

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final RegisterEmailController registerEmailController = Get.find();
  final AuthController authController = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: SizedBox(
          height: Get.height * 0.95,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign Up With Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.asset('assets/image/login_account.png'),
                ),
                FormContainerWidget(
                  controller: emailController,
                  hintText: 'Email Address',
                ),
                FormContainerWidget(
                  controller: passwordController,
                  hintText: 'Password',
                  isPasswordField: true,
                ),
                FormContainerWidget(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPasswordField: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                          value: registerEmailController.isAgreed.value,
                          onChanged: (value) {
                            registerEmailController.isAgreed.value = value!;
                          }),
                    ),
                    const Text("I agree to terms & conditions"),
                  ],
                ),
                const Text(
                  "By continuing, I agree to Alan Mind's Terms of Service. I also consent to the use of my app usage data to improve MindPeers and the relevancy of advertising campaigns for the app. Alan Mind will never use your journal entries: only you can read them. See our Privacy Policy for more information",
                  style: TextStyle(fontSize: 12),
                ),
                Obx(
                  () => CustomButton(
                    text: "Sign Up",
                    isLoading: authController.isLoading.value,
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter an email',
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
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        Get.snackbar(
                          'Error',
                          'Passwords do not match',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      if (passwordController.text.length < 6) {
                        Get.snackbar(
                          'Error',
                          'Password must be at least 6 characters',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (!registerEmailController.isAgreed.value) {
                        Get.snackbar(
                          'Error',
                          'You must agree to the terms and conditions',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      if (emailController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter an email',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      if (passwordController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter a password',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      await authController.registerWithEmail(
                        emailController.text,
                        passwordController.text,
                      );
                    },
                    isDisabled: !registerEmailController.isAgreed.value ||
                        authController.isLoading.value,
                  ),
                ),
                // const SizedBox(),
                // const SizedBox(),
                // const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
