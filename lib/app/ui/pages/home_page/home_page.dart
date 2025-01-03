import 'package:emotion_tracker/app/ui/pages/calendar_page/calendar_page.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/friends_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
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
              const Center(
                child: Text('Notification Page'),
              ),
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
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.person_2),
                ),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Icon(CupertinoIcons.bell),
                ),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
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
}
