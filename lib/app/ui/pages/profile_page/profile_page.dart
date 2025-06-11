import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/uid_controller.dart';
import 'package:emotion_tracker/app/ui/pages/about_page/about_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/dark_mode_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_qr_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = GetStorage();
  bool isOn = false;

  final ProfilePageController profilePageController = Get.find();
  final JournalController journalController = Get.find();
  final UidController uidController = Get.put(UidController());
  Time selectedTime = Time(hour: 21, minute: 0, second: 0);

  @override
  void initState() {
    super.initState();
    profilePageController.getCurrentUserProfile();
    uidController.getCurrentUserUid(FirebaseAuth.instance.currentUser!.uid);
    isOn = box.read('isOn') ?? false;
    selectedTime = readTime();
  }

  Time readTime() {
    final timeMap = box.read('time');
    if (timeMap != null) {
      return Time(
        hour: timeMap['hour'],
        minute: timeMap['minute'],
        second: timeMap['second'],
      );
    }
    return Time(hour: 21, minute: 0, second: 0);
  }

  Future<void> saveTime(Time time) async {
    final timeMap = {
      'hour': time.hour,
      'minute': time.minute,
      'second': time.second
    };
    box.write('time', timeMap);
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final notification = await Permission.notification.status;
    if (notification.isDenied) {
      Get.snackbar(
        'Error',
        'Notification permission denied!.\nClick here to grant permission',
        icon: const Icon(Icons.warning, color: Colors.red),
        onTap: (snack) {
          openAppSettings();
        },
      );

      closeAlarm();
      final res = await Permission.notification.request();
      if (res.isGranted) {
        Get.snackbar(
          'Success',
          'Notification permission granted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  void setAlarm(Time selectedTime) async {
    await saveTime(selectedTime);
    box.write('isOn', isOn);
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
      selectedTime.second,
    );
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: 1,
        dateTime: selectedDateTime.add(
          Duration(days: now.isAfter(selectedDateTime) ? 1 : 0),
        ),
        assetAudioPath: 'assets/audio/alarm2.mp3',
        notificationSettings: const NotificationSettings(
          title: 'Emotion tracker',
          body: 'Let\'s track your emotions',
          stopButton: 'Stop the alarm',
          icon: 'notification_icon',
        ),
      ),
    );
  }

  Future<void> closeAlarm() async {
    await Alarm.stop(1);
    await Alarm.stop(2);
    setState(() {
      isOn = false;
    });
    box.write('isOn', false);
  }

  @override
  Widget build(BuildContext context) {
    profilePageController.onInit();
    profilePageController.getCurrentUserProfile();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: null,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: Text(
            "Profile",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.05),
              _buildProfileSection(),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Hero(
                tag: "profile_${FirebaseAuth.instance.currentUser!.uid}",
                child: SizedBox(
                  height: Get.width * 0.3,
                  width: Get.width * 0.3,
                  child: Obx(
                    () => profilePageController.userProfile.value != null
                        ? AvatarPlus(
                            "${FirebaseAuth.instance.currentUser!.uid}${profilePageController.userProfile.value!.name}",
                          )
                        : SvgPicture.asset('assets/image/avatar.svg'),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.01),
        Center(
          child: Obx(
            () => Column(
              children: [
                Text(
                  profilePageController.userProfile.value?.name ??
                      FirebaseAuth.instance.currentUser!.displayName ??
                      '',
                  style: TextStyle(
                    color: profilePageController.userProfile.value?.gender ==
                            "Gender.Female"
                        ? Colors.pink
                        : Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profilePageController.userProfile.value != null
                          ? "${DateTime.now().difference(profilePageController.userProfile.value!.dob.toDate()).inDays ~/ 365}"
                          : "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color:
                            profilePageController.userProfile.value?.gender ==
                                    "Gender.Female"
                                ? Colors.pink
                                : Colors.blue,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 2,
                      color: Colors.grey,
                      height: 20,
                    ),
                    profilePageController.userProfile.value != null
                        ? Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: profilePageController
                                .userProfile.value!.gender
                                .split(".")
                                .last,
                            child: Icon(
                              profilePageController.userProfile.value!.gender ==
                                      "Gender.Male"
                                  ? Icons.male
                                  : profilePageController
                                              .userProfile.value!.gender ==
                                          "Gender.Female"
                                      ? Icons.female
                                      : CupertinoIcons.question_circle,
                              color: profilePageController
                                          .userProfile.value!.gender ==
                                      "Gender.Female"
                                  ? Colors.pink
                                  : Colors.blue,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  uidController.hasUserName.value
                      ? "@${uidController.username.value}"
                      : FirebaseAuth.instance.currentUser!.uid.toString(),
                  // "uid: ${FirebaseAuth.instance.currentUser!.uid}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              IconButton(
                iconSize: Get.width * 0.03,
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: uidController.hasUserName.value
                          ? "@${uidController.username.value}"
                          : FirebaseAuth.instance.currentUser!.uid.toString(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.copy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildListTile(
          onTap: () => Get.toNamed('/profile/edit'),
          leading: const Icon(CupertinoIcons.person),
          title: "Profile",
        ),
        _buildAlarmTile(),
        if (isOn) _buildSetAlarmTile(),
        _buildListTile(
          onTap: () {
            Get.to(
              () => const QrCodePage(),
            );
          },
          leading: const Icon(CupertinoIcons.qrcode),
          title: "QR Code",
        ),
        _buildListTile(
          onTap: () {
            Get.to(
              () => DarkModePage(),
              transition: Transition.rightToLeft,
            );
          },
          leading: const Icon(Icons.dark_mode_outlined),
          title: "Dark Mode",
        ),
        _buildListTile(
          onTap: () {
            Get.to(
              () => const AboutPage(),
              transition: Transition.rightToLeft,
            );
          },
          leading: const Icon(CupertinoIcons.exclamationmark_bubble),
          title: "About Our App",
        ),
        _buildLogoutTile(),
      ],
    );
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required Widget leading,
    required String title,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        isThreeLine: false,
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          CupertinoIcons.right_chevron,
          weight: 20,
        ),
      ),
    );
  }

  Widget _buildAlarmTile() {
    return ListTile(
      isThreeLine: false,
      leading: const Icon(CupertinoIcons.bell),
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
            inactiveTrackColor: const Color.fromARGB(255, 27, 36, 85),
            activeTrackColor: const Color.fromARGB(255, 75, 39, 255),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            activeThumbImage: const AssetImage('assets/image/check.png'),
            inactiveThumbImage: const AssetImage('assets/image/red_cross.png'),
            value: isOn,
            onChanged: (value) async {
              setState(() {
                isOn = value;
              });
              if (isOn) {
                await checkAndroidScheduleExactAlarmPermission();
                setAlarm(selectedTime);
              } else {
                closeAlarm();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSetAlarmTile() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          showPicker(
            context: context,
            value: selectedTime,
            onChange: (value) async {
              setState(() {
                selectedTime = value;
                setAlarm(value);
              });
            },
          ),
        );
      },
      child: ListTile(
        isThreeLine: false,
        leading: SvgPicture.asset('assets/image/clock.svg'),
        title: const Text(
          "Set Alarm",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedTime.format(context),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return InkWell(
      onTap: () async {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          backgroundColor: Get.theme.canvasColor,
          textColor: Get.theme.colorScheme.onSurface,
          text: 'Do you want to logout',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          confirmBtnColor: Colors.red,
          onCancelBtnTap: () => Get.back(),
          onConfirmBtnTap: () async {
            await FirebaseAuth.instance.signOut();
            journalController.journals.clear();
            Get.offAllNamed("/home");
          },
        );
      },
      child: const ListTile(
        isThreeLine: false,
        leading: Icon(Icons.logout),
        title: Text(
          "Log out",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
