import 'dart:async';
import 'package:alarm/alarm.dart';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = GetStorage();
  bool isOn = false;
  bool _showBubble = false;

  final ProfilePageController profilePageController = Get.find();
  final JournalController journalController = Get.find();
  Time selectedTime = Time(hour: 21, minute: 0, second: 0);

  @override
  void initState() {
    profilePageController.getCurrentUserProfile();
    super.initState();
    isOn = box.read('isOn') ?? false;
    selectedTime = readTime();
  }

  void _onAvatarTap() {
    setState(() {
      _showBubble = true;
    });

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showBubble = false;
        });
      }
    });
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
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: const Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              tooltip: "profile setting",
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          )
        ],
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
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SizedBox(
                height: Get.width * 0.3,
                width: Get.width * 0.3,
                child: Obx(
                  () => profilePageController.userProfile.value != null
                      ? InkWell(
                          borderRadius: BorderRadius.circular(80),
                          onTap: _onAvatarTap,
                          child: AvatarPlus(
                            "${FirebaseAuth.instance.currentUser!.uid}${profilePageController.userProfile.value!.name}",
                          ),
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(80),
                          onTap: _onAvatarTap,
                          child: SvgPicture.asset('assets/image/avatar.svg'),
                        ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                Get.width * 0.15,
                -Get.height * 0.08,
                0,
              ),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onTap: () {},
                child: Obx(
                  () => profilePageController.userProfile.value?.emoji != null
                      ? const CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: AnimatedEmoji(
                            AnimatedEmojis.dizzy,
                            errorWidget: Text('💫'),
                          ),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            if (_showBubble)
              Transform(
                transform: Matrix4.translationValues(
                  -Get.width * 0.28,
                  -Get.height * 0.04,
                  0,
                ),
                child: SizedBox(
                  width: Get.width * 0.4,
                  child: const BubbleSpecialThree(
                    color: Colors.black26,
                    text:
                        "you have to change your name to change your profile picture",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    tail: true,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: Get.height * 0.05),
        Center(
          child: Obx(
            () => Column(
              children: [
                Text(
                  profilePageController.userProfile.value?.name ??
                      FirebaseAuth.instance.currentUser!.displayName ??
                      '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Text(
                      profilePageController.userProfile.value != null
                          ? "age: ${DateTime.now().difference(profilePageController.userProfile.value!.dob.toDate()).inDays ~/ 365}"
                          : "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: 2,
                      color: Colors.black,
                      height: 20,
                    ),
                    profilePageController.userProfile.value != null
                        ? Icon(
                            profilePageController.userProfile.value!.gender ==
                                    Gender.Male
                                ? Icons.male
                                : profilePageController
                                            .userProfile.value!.gender ==
                                        Gender.Female
                                    ? Icons.female
                                    : CupertinoIcons.news,
                            color: Colors.blue,
                          )
                        : Container(),
                  ],
                )
              ],
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "uid: ${FirebaseAuth.instance.currentUser!.uid}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                iconSize: Get.width * 0.04,
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
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
          leading: SvgPicture.asset('assets/image/profile.svg'),
          title: "Profile",
        ),
        _buildAlarmTile(),
        if (isOn) _buildSetAlarmTile(),
        _buildListTile(
          onTap: () {},
          leading: SvgPicture.asset('assets/image/file.svg'),
          title: "Terms & Conditions",
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
          color: Colors.black,
          weight: 20,
        ),
      ),
    );
  }

  Widget _buildAlarmTile() {
    return ListTile(
      isThreeLine: false,
      leading: SvgPicture.asset('assets/image/bell.svg'),
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
        Get.dialog(
          AlertDialog(
            icon: Transform(
              transform: Matrix4.translationValues(0, -40, 0),
              child: SizedBox(
                width: Get.width * 0.16,
                height: Get.width * 0.16,
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 88, 95, 133),
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
                  journalController.journals.clear();
                  Get.offAllNamed("/home");
                },
                child: const Text("Log out"),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        isThreeLine: false,
        leading: SvgPicture.asset('assets/image/quit.svg'),
        title: const Text(
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
