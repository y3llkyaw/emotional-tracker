import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:get/get.dart';

class NotiController extends GetxController {
  final NotificationService ns = NotificationService();
  var notifications = <Map>[].obs;

  Future<void> getNotification() async {
    notifications.value = await ns.getNoti();
  }
}
