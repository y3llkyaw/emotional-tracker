import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/ui/global_widgets/radio_emoji_selction.dart';
import 'package:emotion_tracker/app/ui/pages/calendar_page/calendar_page.dart';
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
              Center(
                child: RadioEmojiSelection(
                  selectedEmoji: AnimatedEmojis.neutralFace,
                  onEmojiSelected: (value) {},
                ),
              ),
              CalendarPage(),
              const ProfilePage(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ClipRRect(
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
                backgroundColor:
                    Get.isDarkMode ? Colors.black : Colors.grey[200],
                showSelectedLabels: true,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.calendar),
                    label: 'Calendar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.settings),
                    label: 'Setting',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
