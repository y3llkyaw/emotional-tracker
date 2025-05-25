import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/comment_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/posts_page.dart/post_detail_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
                      borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.circular(20),
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
                            onRefresh: () =>
                                postPageController.getFriendPosts(),
                            child: ListView.builder(
                              itemCount: postPageController.friendPosts.length,
                              itemBuilder: (context, index) {
                                final post =
                                    postPageController.friendPosts[index];
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

  final CommentController commentController = Get.put(CommentController());
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Get.height * 0.02,
        left: Get.width * 0.01,
      ),
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
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
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
                        child: SizedBox(
                          width: Get.width * 0.45,
                          height: Get.height * 0.03,
                          child: Text(
                            snapshotData.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: snapshotData.gender.toLowerCase() ==
                                      "gender.male"
                                  ? Colors.blue
                                  : Colors.pink,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                      StreamBuilder(
                        stream: postController.getLikeStream(post),
                        builder: (context, snapshot) {
                          // snapshot.data as List<String?>;
                          final likes = snapshot.data as List<String>? ?? [];
                          return Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  likes.contains(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  if (likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)) {
                                    await postController.unlikePost(post);
                                  } else {
                                    await postController.likePost(post);
                                  }
                                },
                              ),
                              Text(
                                snapshot.data != null
                                    ? likes.length.toString()
                                    : "0",
                                style: TextStyle(
                                  fontSize: Get.width * 0.03,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(width: Get.width * 0.05),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.to(
                                () => PostDetailPage(
                                  postData: post,
                                  profileData: snapshotData,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: const Icon(CupertinoIcons.chat_bubble_2),
                          ),
                          // SizedBox(width: Get.width * 0.05),
                          FutureBuilder(
                            future: commentController.getComments(post),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text("0"),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Error loading comments"),
                                );
                              }
                              final comments = snapshot.data as List?;
                              return Text(
                                (comments?.length ?? 0).toString(),
                                style: TextStyle(
                                  fontSize: Get.width * 0.025,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ],
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
