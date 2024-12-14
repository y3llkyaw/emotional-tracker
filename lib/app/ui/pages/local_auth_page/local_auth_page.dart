import 'dart:developer';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/local_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalAuthPage extends StatefulWidget {
  const LocalAuthPage({Key? key}) : super(key: key);

  @override
  State<LocalAuthPage> createState() => _LocalAuthPageState();
}

class _LocalAuthPageState extends State<LocalAuthPage> {
  final LocalAuthController localAuthController = Get.find();
  final box = GetStorage();

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                AnimatedEmoji(
                  AnimatedEmojis.thinkingFace,
                  size: Get.width * 0.09,
                  errorWidget: Center(
                    child: Text(
                      '😔',
                      style: TextStyle(
                        fontSize: Get.width * 0.06,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Please verify, it\'s you!',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            IconButton(
              color: Colors.black,
              onPressed: () async {
                authenticate();
              },
              icon: const Icon(Icons.lock),
            )
          ],
        ),
      ),
    );
  }

  void authenticate() async {
    final didAuthenticate = await localAuthController.authenticate();
    if (didAuthenticate) {
      log('Local authentication successful');
      box.write("local-auth-verified", true);
      Get.offAllNamed('/home');
    }
  }
}
