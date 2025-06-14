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
                      case "like_post":
                        return _buildLikePostNoti(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
                          snapshot.data![index]["pid"],
                        );
                      case "fr":
                        return _buildFriendRequests(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
                        );
                      case "fr-accept":
                        return _buildFriendAccept(
                          snapshot.data![index]["uid"],
                          snapshot.data![index]["read"],
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

  FutureBuilder<Profile> _buildFriendRequests(String uid, bool read) {
    return FutureBuilder(
      future: pc.getProfileByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonTile();
        } else if (snapshot.hasData) {
          var profile = snapshot.data;
          // return _buildFriendRequestTile(profile, uid, read);
        }
        return _skeletonTile();
      },
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

  FutureBuilder<Profile> _buildFriendAccept(String uid, bool read) {
    return FutureBuilder(
      future: pc.getProfileByUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _skeletonTile();
        } else if (snapshot.hasData) {
          var profile = snapshot.data;

          return _buildFriendAcceptTile(profile, uid, read);
        }
        return _skeletonTile();
      },
    );
  }

  List<Widget> _buildOtherNotifications(List<String> otherNotifications) {
    // Implement this method to build other notifications
    return otherNotifications.map((uid) {
      return FutureBuilder(
        future: pc.getProfileByUid(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _skeletonTile();
          } else if (snapshot.hasData) {
            var profile = snapshot.data as Profile?;
            return _buildOtherNotificationsTile(profile, uid);
          }
          return _skeletonTile();
        },
      );
    }).toList();
  }

  Widget _buildOtherNotificationsTile(Profile? profile, String uid) {
    return ListTile(
      leading: CircleAvatar(child: AvatarPlus("$uid${profile?.name}")),
      title: Text(
        profile?.name ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Get.width * 0.01),
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                await afc.acceptFriendRequest(profile!);
                setState(() {});
              },
              child: afc.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Accept",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
            ),
            SizedBox(width: Get.width * 0.05),
            InkWell(
              onTap: () {},
              child: const Text(
                "Decline",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildFriendAcceptTile(Profile? profile, String uid, bool read) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.width * 0.002),
      child: InkWell(
        onTap: () {
          if (profile != null) {
            nc.readNoti(uid);
            Get.to(
              () => FriendProfilePage(profile: profile),
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            child: AvatarPlus("$uid${profile?.name}"),
          ),
          title: Row(
            children: [
              Text(
                "${profile?.name}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: Get.width * 0.04),
              Icon(
                CupertinoIcons.check_mark_circled,
                size: Get.width * 0.04,
                color: Colors.green,
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: Get.width * 0.01),
            child: const Text("accepted your friend request"),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ),
      ),
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
