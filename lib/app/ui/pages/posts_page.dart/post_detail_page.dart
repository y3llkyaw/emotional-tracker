import 'package:avatar_plus/avatar_plus.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:emotion_tracker/app/controllers/comment_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/create_post_page/create_post_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  final Post postData;
  final Profile profileData;

  const PostDetailPage(
      {Key? key, required this.postData, required this.profileData})
      : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isExpanded = false;
  static const int _maxLines = 4;
  final CommentController commentController = Get.put(CommentController());
  final PostController postController = Get.put(PostController());
  final TextEditingController _commentController = TextEditingController();
  final ElTooltipController _tooltipController = ElTooltipController();

  @override
  void initState() {
    super.initState();
    commentController.commentList.clear();
    commentController.getComments(widget.postData);
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.01,
        ),
        child: Column(
          children: [
            // Post Card
            Card(
              color: Colors.indigo.withOpacity(0.1),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.01,
                  horizontal: Get.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          child: AvatarPlus(
                            "${widget.profileData.uid}${widget.profileData.name}",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.profileData.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    widget.profileData.gender.toLowerCase() ==
                                            "gender.male"
                                        ? Colors.blue
                                        : Colors.pink,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.1,
                              decoration: BoxDecoration(
                                color:
                                    widget.profileData.gender.toLowerCase() ==
                                            "gender.male"
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.profileData.gender.toLowerCase() ==
                                            "gender.male"
                                        ? Icons.male
                                        : Icons.female,
                                    size: 15,
                                    color: widget.profileData.gender
                                                .toLowerCase() ==
                                            "gender.male"
                                        ? Colors.blue
                                        : Colors.pink,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.profileData.age.toString(),
                                    style: TextStyle(
                                      fontSize: Get.width * 0.025,
                                      color: widget.profileData.gender
                                                  .toLowerCase() ==
                                              "gender.male"
                                          ? Colors.blue
                                          : Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            SafeArea(
                              child: ElTooltip(
                                controller: _tooltipController,
                                showArrow: true,
                                color: Colors.blue.withOpacity(0.4),
                                appearAnimationDuration:
                                    const Duration(milliseconds: 300),
                                disappearAnimationDuration:
                                    const Duration(milliseconds: 300),
                                position: ElTooltipPosition.bottomEnd,
                                content: widget.postData.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),
                                            onPressed: () {
                                              _tooltipController.hide();
                                              Get.to(
                                                () => CreatePostPage(
                                                  isEditing: true,
                                                  post: widget.postData,
                                                ),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            label: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.edit,
                                              size: Get.width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              _tooltipController.hide();
                                              Get.to(
                                                () => CreatePostPage(
                                                  isEditing: true,
                                                  post: widget.postData,
                                                ),
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            },
                                            label: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.delete,
                                              size: Get.width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                            ),
                                            onPressed: () async {
                                              _tooltipController.hide();
                                              await postController
                                                  .hidePost(widget.postData)
                                                  .then((value) {});
                                              // TODO: Implement hide post functionality
                                            },
                                            label: const Text(
                                              "Hide",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              CupertinoIcons.eye_slash,
                                              size: Get.width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                            ),
                                            onPressed: () async {
                                              _tooltipController.hide();
                                              showReportBottomSheet(
                                                widget.postData,
                                              );
                                            },
                                            label: const Text(
                                              "Report",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.report,
                                              size: Get.width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Text(
                              timeago.format(
                                widget.postData.createdAt,
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
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Post body with see more/less
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final span = TextSpan(
                          text: widget.postData.body,
                          style: TextStyle(fontSize: Get.width * 0.037),
                        );
                        final tp = TextPainter(
                          text: span,
                          maxLines: _maxLines,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        final isOverflow = tp.didExceedMaxLines;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                widget.postData.body,
                                style: TextStyle(fontSize: Get.width * 0.037),
                                maxLines: _isExpanded ? null : _maxLines,
                                overflow: _isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOverflow)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    _isExpanded ? "See less" : "See more",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Get.width * 0.032,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 16,
                      child: Divider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 0.5,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder(
                          stream: postController.getLikeStream(widget.postData),
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
                                    if (likes.contains(FirebaseAuth
                                        .instance.currentUser!.uid)) {
                                      await postController
                                          .unlikePost(widget.postData);
                                    } else {
                                      await postController
                                          .likePost(widget.postData);
                                    }
                                  },
                                ),
                                Text(
                                  likes.isEmpty
                                      ? ""
                                      : snapshot.data != null
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
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.chat_bubble_2,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // Handle comment action
                              },
                            ),
                            // Text(
                            //   widget.postData.comments?.length.toString() ?? "",
                            //   style: TextStyle(
                            //     fontSize: Get.width * 0.03,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: Get.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Comments list (not Expanded, just a Column of ListTiles)
            const SizedBox(height: 8),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: commentController.commentList.length,
                itemBuilder: (context, index) {
                  final comment = commentController.commentList[index];
                  return CommentWidget(
                    comment: comment,
                    post: widget.postData,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextField(
          controller: _commentController,
          onChanged: (value) {
            commentController.comment.value = value;
            // Handle comment input
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(),
            suffixIcon: Obx(
              () => IconButton(
                icon: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: commentController.comment.value.isEmpty
                      ? Colors.grey
                      : Colors.blue,
                ),
                onPressed: commentController.comment.value.isEmpty
                    ? null
                    : () async {
                        await commentController
                            .addComment(
                          widget.postData,
                        )
                            .then((v) {
                          commentController.getComments(widget.postData);
                        });

                        commentController.comment.value = "";
                        _commentController.clear();
                      },
              ),
            ),
            hintText: 'Write a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  CommentWidget({
    Key? key,
    required this.comment,
    required this.post,
  }) : super(key: key);

  final Comment comment;
  final Post post;
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());
  final CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: profilePageController.getProfileByUid(comment.uid),
        builder: (context, snapshot) {
          final profile = snapshot.data as Profile?;
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Shimmer effect while loading profile
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: Get.height * 0.01,
                ),
                child: ListTile(
                  isThreeLine: true,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                  ),
                  title: Container(
                    width: Get.width * 0.2,
                    height: 12,
                    color: Colors.white,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Container(
                        width: Get.width * 0.4,
                        height: 10,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (profile == null) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: ListTile(
              onLongPress: () {
                showDeleteCommentBottomSheet(comment: comment, post: post);
              },
              isThreeLine: true,
              leading: CircleAvatar(
                child: AvatarPlus(
                  "${comment.uid}${profile.name}",
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (profile.uid ==
                              FirebaseAuth.instance.currentUser!.uid) {
                            Get.to(
                              () => const ProfilePage(),
                              transition: Transition.rightToLeft,
                            );
                          } else {
                            Get.to(
                              () => OtherProfilePage(profile: profile),
                              transition: Transition.rightToLeft,
                            );
                          }
                        },
                        child: Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: Get.width * 0.03,
                            fontWeight: FontWeight.w600,
                            color: profile.gender.toLowerCase() == "gender.male"
                                ? Colors.blue
                                : Colors.pink,
                          ),
                        ),
                      ),
                      Container(
                        width: Get.width * 0.1,
                        decoration: BoxDecoration(
                          color: profile.gender.toLowerCase() == "gender.male"
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.pink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              profile.gender.toLowerCase() == "gender.male"
                                  ? Icons.male
                                  : Icons.female,
                              size: 12,
                              color:
                                  profile.gender.toLowerCase() == "gender.male"
                                      ? Colors.blue
                                      : Colors.pink,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              profile.age.toString(),
                              style: TextStyle(
                                fontSize: Get.width * 0.022,
                                color: profile.gender.toLowerCase() ==
                                        "gender.male"
                                    ? Colors.blue
                                    : Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    timeago.format(
                      comment.createdAt,
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.comment,
                    style: TextStyle(
                      fontSize: Get.width * 0.03,
                    ),
                  ),
                ],
              ),
              trailing: StreamBuilder<List<String>>(
                  stream:
                      commentController.commentLikesStream(post, comment.id),
                  builder: (context, snapshot) {
                    final likeList = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () async {
                            if (likeList?.contains(
                                    FirebaseAuth.instance.currentUser!.uid) ??
                                false) {
                              await commentController.unlikeComment(
                                  post, comment.id);
                            } else {
                              await commentController.likeComment(
                                  post, comment.id);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              (likeList?.contains(FirebaseAuth
                                          .instance.currentUser!.uid) ??
                                      false)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: Get.width * 0.05,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data?.length.toString() ?? "0",
                          style: TextStyle(
                            fontSize: Get.width * 0.02,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
