import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:day_night_time_picker/lib/state/time.dart';

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

    Get.put<NavigationController>(NavigationController());
    Get.put<MainController>(MainController());
  }
}
