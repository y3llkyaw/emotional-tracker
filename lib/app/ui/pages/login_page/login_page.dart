import 'package:emotion_tracker/app/controllers/auth_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:emotion_tracker/app/ui/global_widgets/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                child: Image.asset('assets/image/login_account.png'),
              ),
              FormContainerWidget(
                hintText: 'Email Address',
                controller: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              FormContainerWidget(
                hintText: 'Password',
                isPasswordField: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
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
              const SizedBox(
                height: 20,
              ),
              OutlineButtonWidget(
                asset: "assets/image/google.svg",
                text: "Login with Google",
                onPressed: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              OutlineButtonWidget(
                asset: "assets/image/facebook.svg",
                text: "Login with Facebook",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
