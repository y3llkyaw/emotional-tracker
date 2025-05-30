import 'package:emotion_tracker/app/controllers/local_auth_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/uid_controller.dart';
import 'package:emotion_tracker/app/ui/pages/profile_update_page/change_birthday_page/change_birthday_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_update_page/username_update_page/username_update_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final nameController = TextEditingController();
  final ProfilePageController controller = Get.find();
  final LocalAuthController localAuthController = Get.find();
  final UidController uidController = Get.put(UidController());

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser!.reload();
    uidController.getCurrentUserUid(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    controller.getCurrentUserProfile();
    uidController.getCurrentUserUid(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // name update
            InkWell(
              onTap: () {
                Get.toNamed("profile/update/name");
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(Icons.person),
                title: Text(
                  "Display Name",
                  style: Get.theme.textTheme.titleMedium,
                ),
                subtitle: Obx(
                  () => Text(
                    controller.userProfile.value!.name.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  weight: 20,
                ),
              ),
            ),
            // User Id
            InkWell(
              onTap: () async {
                // Get.toNamed("profile/update/name");
                await Get.to(() => const UsernameUpdatePage());
                setState(() {});
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(CupertinoIcons.doc_person),
                title: Row(
                  children: [
                    Text(
                      "username",
                      style: Get.theme.textTheme.titleMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Obx(
                      () => Icon(
                        uidController.hasUserName.value
                            ? Icons.check_circle
                            : Icons.error,
                        size: 14,
                        color: uidController.hasUserName.value
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                subtitle: Obx(
                  () => Text(
                    uidController.username.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  weight: 20,
                ),
              ),
            ),
            // Email
            InkWell(
              onTap: () {
                Get.toNamed("profile/update/email");
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(
                  CupertinoIcons.mail,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Email ",
                      style: Get.theme.textTheme.titleMedium,
                    ),
                    Icon(
                      FirebaseAuth.instance.currentUser!.emailVerified
                          ? Icons.check_circle
                          : Icons.error,
                      size: 14,
                      color: FirebaseAuth.instance.currentUser!.emailVerified
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
                subtitle: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  weight: 20,
                ),
              ),
            ),

            // Birthday
            InkWell(
              onTap: () async {
                await Get.to(
                    ChangeBirthdayPage(
                      birthday: controller.userProfile.value!.dob.toDate(),
                    ),
                    transition: Transition.rightToLeft);
                setState(() {});
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(
                  Icons.cake,
                ),
                title: Text(
                  "Birthday",
                  style: Get.theme.textTheme.titleMedium,
                ),
                subtitle: Obx(
                  () => Text(
                    controller.userProfile.value!.dob
                        .toDate()
                        .toString()
                        .split(' ')[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  weight: 20,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed("profile/update/password");
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.09),
                isThreeLine: false,
                leading: const Icon(
                  CupertinoIcons.lock,
                ),
                title: Text(
                  "Password",
                  style: Get.theme.textTheme.titleMedium,
                ),
                subtitle: const Text(
                  "change your password",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  CupertinoIcons.right_chevron,
                  weight: 20,
                ),
              ),
            ),
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.09),
              isThreeLine: false,
              leading: const Icon(
                CupertinoIcons.lock_circle,
              ),
              title: Text(
                "App Lock",
                style: Get.theme.textTheme.titleMedium,
              ),
              subtitle: const Text(
                "turn on lock App",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: Obx(
                () => SizedBox(
                  height: Get.width * 0.09,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Switch(
                      inactiveTrackColor: const Color.fromARGB(255, 27, 36, 85),
                      activeTrackColor: const Color.fromARGB(255, 75, 39, 255),
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      activeThumbImage: const AssetImage(
                        'assets/image/check.png',
                      ),
                      inactiveThumbImage: const AssetImage(
                        'assets/image/red_cross.png',
                      ),
                      value: localAuthController.isEnabled.value,
                      onChanged: (value) async {
                        localAuthController.toggleLocalAuth();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
