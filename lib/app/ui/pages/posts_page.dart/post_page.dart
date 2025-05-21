import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPage extends StatelessWidget {
  PostPage({Key? key}) : super(key: key);

  final PostController postPageController = Get.put(PostController());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.public,
                            color: postPageController.index.value == 0
                                ? Colors.blue
                                : Get.theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Public",
                            style: TextStyle(
                              color: postPageController.index.value == 0
                                  ? Colors.blue
                                  : Get.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: postPageController.index.value == 1
                                ? Colors.blue
                                : Get.theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Friends",
                            style: TextStyle(
                              color: postPageController.index.value == 1
                                  ? Colors.blue
                                  : Get.theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  postPageController.index.value = page;
                },
                children: [
                  Obx(() {
                    return postPageController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => postPageController.getPublicPost(),
                            child: ListView.builder(
                              itemCount: postPageController.publicPosts.length,
                              itemBuilder: (context, index) {
                                final post =
                                    postPageController.publicPosts[index];
                                return PostWidget(post: post);
                              },
                            ),
                          );
                  }),
                  Obx(() {
                    return postPageController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => postPageController.getMyPosts(),
                            child: ListView.builder(
                              itemCount: postPageController.myPosts.length,
                              itemBuilder: (context, index) {
                                final post = postPageController.myPosts[index];
                                return PostWidget(post: post);
                              },
                            ),
                          );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  PostWidget({Key? key, required this.post}) : super(key: key);

  final Post post;
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Get.height * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder(
          future: profilePageController.getProfileByUid(post.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading post"),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No data found"),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("No data found"),
              );
            }
            final snapshotData = snapshot.data as Profile;
            return ListTile(
              isThreeLine: true,
              leading: InkWell(
                onTap: () {
                  Get.to(
                    () => OtherProfilePage(
                      profile: snapshotData,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: AvatarPlus(
                        "${post.uid}${snapshotData.name}",
                      ),
                    ),
                  ],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            () => OtherProfilePage(
                              profile: snapshotData,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          snapshotData.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: snapshotData.gender.toLowerCase() ==
                                    "gender.male"
                                ? Colors.blue
                                : Colors.pink,
                          ),
                        ),
                      ),
                      const Icon(Icons.more_horiz),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.1,
                        decoration: BoxDecoration(
                          color:
                              snapshotData.gender.toLowerCase() == "gender.male"
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.pink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              snapshotData.gender.toLowerCase() == "gender.male"
                                  ? Icons.male
                                  : Icons.female,
                              size: 15,
                              color: snapshotData.gender.toLowerCase() ==
                                      "gender.male"
                                  ? Colors.blue
                                  : Colors.pink,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              snapshotData.age.toString(),
                              style: TextStyle(
                                fontSize: Get.width * 0.025,
                                color: snapshotData.gender.toLowerCase() ==
                                        "gender.male"
                                    ? Colors.blue
                                    : Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        timeago.format(
                          post.createdAt,
                          locale: 'en_short',
                          allowFromNow: true,
                          clock: DateTime.now(),
                        ),
                        style: TextStyle(
                          fontSize: Get.width * 0.025,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.01),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      post.body.trim(),
                      textAlign: TextAlign.start,
                      maxLines: 9,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart),
                      ),
                      SizedBox(width: Get.width * 0.05),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.chat_bubble_2),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
