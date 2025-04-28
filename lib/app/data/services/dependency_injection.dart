import 'package:alarm/alarm.dart';
import 'package:emotion_tracker/app/controllers/darkmode_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';

import '../../controllers/navigation_controller.dart';
import '../../controllers/main_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DependecyInjection {
  static Future<void> init() async {
    // firebase init
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Alarm.init();
    await GetStorage.init();

    AudioPlayer.global.setAudioContext(
      const AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification, // <-- Very important
          usageType:
              AndroidUsageType.assistanceSonification, // <-- Very important
          audioFocus: AndroidAudioFocus.none, // <-- Super important!!!
        ),
        iOS: AudioContextIOS(
          category:
              AVAudioSessionCategory.ambient, // iOS won't interrupt other music
          options: [AVAudioSessionOptions.mixWithOthers],
        ),
      ),
    );
    // Add observer

    Alarm.ringStream.stream
        .listen(
      (_) {},
    )
        .onData((setting) {
      Alarm.set(
        alarmSettings: AlarmSettings(
          id: setting.id == 1 ? 2 : 1,
          dateTime: setting.dateTime.add(
            const Duration(days: 1),
          ),
          assetAudioPath: 'assets/audio/alarm2.mp3',
          notificationSettings: const NotificationSettings(
            title: "This is the title",
            body: "This is the body",
            stopButton: "Stop",
            icon: "notification_icon",
          ),
        ),
      );
    });
    Get.put(MatchingController());
    Get.put<NavigationController>(NavigationController());
    Get.put<MainController>(MainController());
    Get.put(DarkmodeController());
  }
}
