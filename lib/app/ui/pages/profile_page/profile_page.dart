import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var isOn = false;

  final ProfilePageController profilePageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),

              // profile goes here
              Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: Get.width * 0.3,
                      width: Get.width * 0.3,
                      child: SvgPicture.asset(
                        'assets/image/avatar.svg',
                        height: 250,
                        width: 250,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Center(
                    child: Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // setting sections goes here
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/profile/edit');
                    },
                    child: ListTile(
                      isThreeLine: false,
                      leading: SvgPicture.asset(
                        'assets/image/profile.svg',
                      ),
                      title: const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black,
                        weight: 20,
                      ),
                    ),
                  ),

                  // Daily Alarm
                  ListTile(
                    isThreeLine: false,
                    leading: SvgPicture.asset(
                      'assets/image/bell.svg',
                    ),
                    title: const Text(
                      "Daily Alarm",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: SizedBox(
                      height: Get.width * 0.09,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Switch(
                          inactiveTrackColor:
                              const Color.fromARGB(255, 27, 36, 85),
                          activeTrackColor:
                              const Color.fromARGB(255, 75, 39, 255),
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          activeThumbImage: const AssetImage(
                            'assets/image/check.png',
                          ),
                          inactiveThumbImage: const AssetImage(
                            'assets/image/red_cross.png',
                          ),
                          value: isOn,
                          onChanged: (value) {
                            setState(
                              () {
                                isOn = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      isThreeLine: false,
                      leading: SvgPicture.asset(
                        'assets/image/clock.svg',
                      ),
                      title: const Text(
                        "Set Alarm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black,
                        weight: 20,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      isThreeLine: false,
                      leading: SvgPicture.asset(
                        'assets/image/file.svg',
                      ),
                      title: const Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.black,
                        weight: 20,
                      ),
                    ),
                  ),
                  // log out
                  InkWell(
                    onTap: () async {
                      Get.dialog(
                        AlertDialog(
                          icon: Transform(
                            transform: Matrix4.translationValues(0, -40, 0),
                            child: SizedBox(
                              width: Get.width * 0.16,
                              height: Get.width * 0.16,
                              child: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 88, 95, 133),
                                radius: 20,
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            "Are you sure you want to log out?",
                            style: TextStyle(fontSize: Get.height * 0.02),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Get.offAllNamed("/home");
                              },
                              child: const Text("Log out"),
                            ),
                          ],
                        ),
                      );

                      // await FirebaseAuth.instance.signOut();
                      // Get.offAllNamed("/home");
                    },
                    child: ListTile(
                      isThreeLine: false,
                      leading: SvgPicture.asset(
                        'assets/image/quit.svg',
                      ),
                      title: const Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Obx(
              //   () => Center(
              //     child: Text(
              //       profilePageController.userProfile.name,
              //       style: const TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // Center(
              //   child: Text(
              //     FirebaseAuth.instance.currentUser!.email!,
              //     style: const TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
