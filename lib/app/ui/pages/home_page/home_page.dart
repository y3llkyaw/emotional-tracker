import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/ui/pages/calendar_page/calendar_page.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/friends_page.dart';
import 'package:emotion_tracker/app/ui/pages/notification_page/notification_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  final noti = NotiController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: homeController.pageIndex.value,
            children: [
              CalendarPage(),
              FriendsPage(),
              const NotificationPage(),
              const ProfilePage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: homeController.pageIndex.value,
            onTap: (index) {
              homeController.changeIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.grey[200],
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.home),
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.person_2),
                ),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Stack(
                    children: [
                      const Icon(CupertinoIcons.bell),
                      StreamBuilder(
                        stream: noti.streamNoti(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data is List) {
                            if ((snapshot.data as List).isEmpty) {
                              return const SizedBox();
                            }
                            return _redMark((snapshot.data as List).length);
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    ],
                  ),
                ),
                label: 'Notification',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.settings),
                ),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _redMark(int count) {
    return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(6),
        ),
        constraints: const BoxConstraints(
          minWidth: 12,
          minHeight: 12,
        ),
        child: Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: Get.width * 0.02,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
