import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/ui/pages/posts_page.dart/post_detail_page.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotiController nc = Get.put(NotiController());

  @override
  void initState() {
    super.initState();
    nc.getAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.grey,
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) async {
              if (value == 'mark_all_read') {
                await nc.markAllUnreadAsRead();
              }
              if (value == 'delete_all') {
                await nc.deleteAllNotifications();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'mark_all_read',
                child: ListTile(
                  leading: Icon(Icons.done_all),
                  title: Text('Mark all as read'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete_all',
                child: ListTile(
                  leading: Icon(Icons.delete_forever),
                  title: Text('Delete All Noti'),
                ),
              ),
              // Add more actions here if needed
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Obx(() {
          final list = nc.enrichedNotifications;
          if (list.isEmpty) {
            return Center(
              child: Text(
                "You have no notifications right now!",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Get.width * 0.036,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              switch (item['type']) {
                case "like_post":
                  return buildLikePostTile(item);
                case "comment_post":
                  return buildCommentTile(item);
                case "like_comment":
                  return buildLikeCommentTile(item);
                default:
                  return Container();
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildLikePostTile(Map<String, dynamic> item) {
    final profile = item['profile'];
    final post = item['post'];
    final isRead = item['read'] == true;
    final Timestamp ts = item['created_at'];

    return InkWell(
      onTap: () async {
        if (post != null) {
          Get.to(() => PostDetailPage(postData: post));
          await nc.readNoti(item['id']);
        }
        await nc.readNoti(item['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : Colors.blue.withOpacity(0.08),
          border: Border(
            left: BorderSide(
              color: isRead ? Colors.transparent : Colors.blue,
              width: 4,
            ),
          ),
        ),
        child: ListTile(
          leading: buildAvatar(profile.uid, profile.name,
              icon: CupertinoIcons.heart_fill),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: profile.name,
                  style: TextStyle(
                    color: profile.color,
                  ),
                ),
                const TextSpan(text: " liked your post: "),
                TextSpan(text: post?.body ?? "you deleted!"),
                TextSpan(
                  text: "  ${timeago.format(ts.toDate())}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget buildCommentTile(Map<String, dynamic> item) {
    final profile = item['profile'];
    final post = item['post'];
    final isRead = item['read'] == true;
    final ts = item['created_at'] as Timestamp;

    return InkWell(
      onTap: () async {
        if (post != null) {
          Get.to(() => PostDetailPage(postData: post));
          await nc.readNoti(item['id']);
        }
        await nc.readNoti(item['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : Colors.blue.withOpacity(0.08),
          border: Border(
            left: BorderSide(
              color: isRead ? Colors.transparent : Colors.blue,
              width: 4,
            ),
          ),
        ),
        child: ListTile(
          leading: buildAvatar(profile.uid, profile.name,
              icon: CupertinoIcons.chat_bubble_fill),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: profile.name,
                  style: TextStyle(color: profile.color),
                ),
                const TextSpan(text: " commented on your post: "),
                TextSpan(text: post?.body ?? "you deleted!"),
                TextSpan(
                  text: "  ${timeago.format(ts.toDate())}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget buildLikeCommentTile(Map<String, dynamic> item) {
    final profile = item['profile'];
    final post = item['post'];
    final comment = item['comment'];
    final isRead = item['read'] == true;
    final ts = item['created_at'] as Timestamp;

    return InkWell(
      onTap: () async {
        if (post != null) {
          Get.to(() => PostDetailPage(postData: post));
          await nc.readNoti(item['id']);
        }
        await nc.readNoti(item['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.transparent : Colors.blue.withOpacity(0.08),
          border: Border(
            left: BorderSide(
              color: isRead ? Colors.transparent : Colors.blue,
              width: 4,
            ),
          ),
        ),
        child: ListTile(
          leading: buildAvatar(profile.uid, profile.name,
              icon: CupertinoIcons.heart_fill),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: profile.name,
                  style: TextStyle(color: profile.color),
                ),
                const TextSpan(text: " liked your comment: "),
                TextSpan(text: comment?.comment ?? "deleted comment. "),
                TextSpan(
                  text: "  ${timeago.format(ts.toDate())}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(String uid, String? name, {IconData? icon}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(child: AvatarPlus("$uid$name")),
        if (icon != null)
          Transform.translate(
            offset: const Offset(20, 15),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Icon(icon, size: 15, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
