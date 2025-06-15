import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/posts_page.dart/post_detail_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/friend_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotiController nc = Get.put(NotiController());
  final ProfilePageController pc = Get.put(ProfilePageController());
  final FriendsController afc = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    nc.getAllNotification();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: const Row(
            children: [
              Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.bell_fill,
                ),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Obx(() {
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: nc.notifications.value,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.bell,
                        color: Colors.grey.shade500,
                        size: Get.height * 0.03,
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                      Center(
                        child: Text(
                          "you have no notifications right now !",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Get.width * 0.036,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    switch (snapshot.data![index]['type']) {
                      case "like_comment":
                        return _buildLikeCommentNoti(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
                          snapshot.data![index]["pid"],
                        );
                      case "comment_post":
                        return _buildCommentNoti(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
                          snapshot.data![index]["pid"],
                        );
                      case "like_post":
                        return _buildLikePostNoti(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
                          snapshot.data![index]["pid"],
                        );

                      case "other":
                        // other.add(snapshot.data![index]['uid']);
                        break;
                    }
                    return Container();
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }),
      ),
    );
  }

  FutureBuilder<Profile> _buildLikePostNoti(String uid, bool read, String pid) {
    return FutureBuilder<Profile>(
      future: pc.getProfileByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonTile();
        } else if (snapshot.hasData) {
          var profile = snapshot.data;
          return _buildLikePostTile(profile, uid, read, pid);
        }
        return _skeletonTile();
      },
    );
  }

  FutureBuilder<Profile> _buildCommentNoti(String uid, bool read, String pid) {
    return FutureBuilder<Profile>(
      future: pc.getProfileByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonTile();
        } else if (snapshot.hasData) {
          var profile = snapshot.data;
          return _buildCommentTile(profile, uid, read, pid);
        }
        return _skeletonTile();
      },
    );
  }

  FutureBuilder<Profile> _buildLikeCommentNoti(
      String uid, bool read, String pid) {
    return FutureBuilder<Profile>(
      future: pc.getProfileByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonTile();
        } else if (snapshot.hasData) {
          var profile = snapshot.data;
          return _buildLikeCommentTile(profile, uid, read, pid);
        }
        return _skeletonTile();
      },
    );
  }

  Widget _buildLikePostTile(
      Profile? profile, String uid, bool read, String pid) {
    PostController postController = PostController();

    return FutureBuilder<Post?>(
      future: postController.getPostById(pid),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            if (profile != null) {
              Get.to(
                () => PostDetailPage(
                  postData: snapshot.data!,
                  profileData: profile,
                ),
              );
              await nc.readNoti("like_${snapshot.data!.id}_${profile.uid}");
            }
          },
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  child: AvatarPlus("$uid${profile?.name}"),
                ),
                Transform(
                  transform: Matrix4.translationValues(20, 15, 0),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: profile?.color.withOpacity(0.8) ??
                        Colors.grey.withOpacity(0.1),
                    child: const Icon(
                      CupertinoIcons.heart_fill,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${profile?.name} ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: profile!.color,
                    ),
                  ),
                  const TextSpan(
                    text: "liked your post.",
                  ),
                ],
              ),
            ),
            // subtitle: const Text("your post: ${p}"),
          ),
        );
      },
    );
  }

  Widget _buildLikeCommentTile(
    Profile? profile,
    String uid,
    bool read,
    String pid,
  ) {
    PostController postController = PostController();

    return FutureBuilder<Post?>(
      future: postController.getPostById(pid),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            if (profile != null) {
              Get.to(
                () => PostDetailPage(
                  postData: snapshot.data!,
                  profileData: profile,
                ),
              );
              await nc.readNoti("comment_${snapshot.data!.id}_${profile.uid}");
            }
          },
          child: ListTile(
            leading: CircleAvatar(child: AvatarPlus("$uid${profile?.name}")),
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${profile?.name} ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: profile!.color,
                    ),
                  ),
                  const TextSpan(
                    text: "liked your comment.",
                  ),
                ],
              ),
            ),
            // subtitle: const Text("your post: ${p}"),
          ),
        );
      },
    );
  }

  Widget _buildCommentTile(
    Profile? profile,
    String uid,
    bool read,
    String pid,
  ) {
    PostController postController = PostController();

    return FutureBuilder<Post?>(
      future: postController.getPostById(pid),
      builder: (context, snapshot) {
        return InkWell(
          onTap: () async {
            if (profile != null) {
              Get.to(
                () => PostDetailPage(
                  postData: snapshot.data!,
                  profileData: profile,
                ),
              );
              await nc.readNoti("comment_${snapshot.data!.id}_${profile.uid}");
            }
          },
          child: ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  child: AvatarPlus("$uid${profile?.name}"),
                ),
                Transform(
                  transform: Matrix4.translationValues(20, 15, 0),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: profile?.color.withOpacity(0.8) ??
                        Colors.grey.withOpacity(0.1),
                    child: const Icon(
                      CupertinoIcons.chat_bubble_fill,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${profile?.name} ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: profile!.color,
                    ),
                  ),
                  const TextSpan(
                    text: "commented your post.",
                  ),
                ],
              ),
            ),
            // subtitle: const Text("your post: ${p}"),
          ),
        );
      },
    );
  }

  // Widget _buildExpansionTile({
  //   required IconData icon,
  //   required String title,
  //   required List<Widget> children,
  // }) {
  //   return ExpansionTile(
  //     iconColor: Colors.black,
  //     leading: Icon(icon),
  //     title: Text(title),
  //     children: children,
  //   );
  // }

  Widget _skeletonTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
      title: Container(
        width: 100,
        height: 10,
        color: Colors.grey.shade300,
      ),
      subtitle: Container(
        width: 150,
        height: 10,
        color: Colors.grey.shade300,
      ),
    );
  }
}
