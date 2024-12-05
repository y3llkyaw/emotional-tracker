import 'package:alarm/alarm.dart';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var isOn = false;

  final ProfilePageController profilePageController = Get.find();
  Time selectedTime = Time(hour: 21, minute: 0, second: 0);

  @override
  void initState() {
    super.initState();
    isOn = box.read('isOn') ?? false;
    selectedTime = readTime();
  }

  /// Reads the time from storage and returns a [Time] object representing
  /// the hour, minute and second.
  ///
  /// If no value is stored, a default time of 21:00:00 is returned.
  Time readTime() {
    final timeMap = box.read('time');
    if (timeMap != null) {
      return Time(
        hour: timeMap['hour'],
        minute: timeMap['minute'],
        second: timeMap['second'],
      );
    }
    // Default time if no value is stored
    return Time(hour: 21, minute: 0, second: 0);
  }

  /// Saves the specified [time] to the storage.
  ///
  /// This function saves the time in the form of a map with hour, minute, and
  /// second as keys.
  ///
  /// The saved time is used to set the alarm.

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

  /// Sets the alarm at the specified [selectedTime].
  ///
  /// This function saves the time to the storage, sets the switch to true,
  /// and sets the alarm at the specified time. If the selected time is in the
  /// past, the alarm is set for the next day.
  void setAlarm(Time selectedTime) async {
    await saveTime(selectedTime);
    box.write('isOn', isOn);
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
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

  /// Stops the alarm and sets the switch to false.
  ///
  /// This function is called when the switch is turned off or when the user
  /// clicks the stop button in the notification.
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

              Column(
                children: [
                  // avatar goes here
                  Stack(
                    alignment: Alignment.center,
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
                      Transform(
                        transform: Matrix4.translationValues(
                          Get.width * 0.15,
                          -Get.height * 0.08,
                          0,
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black38,
                          child: AnimatedEmoji(
                            AnimatedEmojis.dizzy,
                            errorWidget: Text(
                              '💫',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Center(
                    child: Obx(
                      () => Text(
                        profilePageController.userProfile.value != null
                            ? profilePageController.userProfile.value!.name
                                .toString()
                            : FirebaseAuth.instance.currentUser!.displayName
                                .toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
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
                          onChanged: (value) async {
                            setState(
                              () {
                                isOn = value;
                              },
                            );
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
                  ),
                  isOn
                      ? InkWell(
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
                        )
                      : const SizedBox(),
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
            ],
          ),
        ),
      ),
    );
  }
}
