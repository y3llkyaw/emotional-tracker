import 'package:animated_emoji/animated_emoji.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/pages/calendar_page/calendar_page.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/friends_page.dart';
import 'package:emotion_tracker/app/ui/pages/matching_page/matching_page.dart';
import 'package:emotion_tracker/app/ui/pages/message_page/message_page.dart';
import 'package:emotion_tracker/app/ui/pages/moodmate/mood_mate_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_page.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  final ProfilePageController profilePageController = Get.find();
  final noti = NotiController();
  final friendController = FriendsController();
  final ChatController chatController = Get.put(ChatController());
  final MatchingController matchingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      autoAlign: true,
      floatingWidgetHeight: Get.height * 0.1,
      floatingWidgetWidth: Get.height * 0.1,
      screenHeight: Get.height,
      screenWidth: Get.width,
      floatingWidget: Obx(
        () {
          return matchingController.isMatching.value
              ? InkWell(
                  onTap: () {
                    Get.to(
                      () => MatchingPage(),
                      transition: Transition.downToUp,
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const AnimatedEmoji(AnimatedEmojis.eyes),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Finding\na MoodMate",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: Get.width * 0.025,
                            ),
                          ),
                        ],
                      )))
              : Container();
        },
      ),
      mainScreenWidget: Scaffold(
        body: SafeArea(
          child: Obx(
            () => IndexedStack(
              index: homeController.pageIndex.value,
              children: [
                CalendarPage(),
                const FriendsPage(),
                // const NotificationPage(),
                MoodMatePage(),
                const MessagePage(),
                const ProfilePage(),
              ],
            ),
          ),
        ),
        // floatingActionButton: Obx(
        //   () {
        //     print(matchingController.isMatching.value);
        //     return matchingController.isMatching.value
        //         ? FloatingActionButton.small(
        //             backgroundColor: Get.theme.colorScheme.error,
        //             onPressed: () {
        //               Get.to(
        //                 () => MatchingPage(),
        //                 transition: Transition.downToUp,
        //               );
        //             },
        //             child: const AnimatedEmoji(AnimatedEmojis.eyes),
        //           )
        //         : Container();
        //   },
        // ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Obx(
                () => BottomNavigationBar(
                  currentIndex: homeController.pageIndex.value,
                  onTap: (index) async {
                    final player = AudioPlayer();
                    await player.play(AssetSource('audio/pop.mp3'));
                    player.onPlayerComplete.listen((event) {
                      player.dispose();
                    });
                    homeController.changeIndex(index);
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: theme.colorScheme.onPrimary,
                  unselectedItemColor: Colors.grey,
                  // backgroundColor: theme.bottomAppBarTheme.,
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
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Stack(
                          children: [
                            const Icon(CupertinoIcons.person_2),
                            StreamBuilder<int>(
                              stream:
                                  friendController.noOfFriendRequestStream(),
                              builder: (context, snapshot) {
                                return snapshot.data == 0
                                    ? const SizedBox()
                                    : _redMark(friendController.noFriReq.value);
                              },
                            ),
                          ],
                        ),
                      ),
                      label: 'Friends',
                    ),
                    const BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(CupertinoIcons.heart),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Stack(
                          children: [
                            const Icon(CupertinoIcons.chat_bubble_2),
                            StreamBuilder(
                              stream: chatController.getUnreadMessageCount(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data is int) {
                                  int count = snapshot.data as int;
                                  if (count == 0) return const SizedBox();
                                  return _redMark(count);
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      label: 'Messages',
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
            );
          },
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
