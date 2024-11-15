import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:emotion_tracker/app/ui/global_widgets/outline_button.dart';
import 'package:emotion_tracker/app/ui/layouts/main/main_layout.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                const FormContainerWidget(
                  hintText: 'Email Address',
                ),
                const SizedBox(
                  height: 20,
                ),
                const FormContainerWidget(
                  hintText: 'Password',
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Log In',
                  isDisabled: false,
                  onPressed: () {},
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
                        // Get.to(() => const CreateAccountScreen());
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
        ));
  }
}
