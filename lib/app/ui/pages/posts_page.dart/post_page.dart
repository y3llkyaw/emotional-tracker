import 'package:avatar_plus/avatar_plus.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:emotion_tracker/app/controllers/comment_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/create_post_page/create_post_page.dart';
import 'package:emotion_tracker/app/ui/pages/posts_page.dart/post_detail_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController postPageController = Get.put(PostController());
  final PageController _pageController = PageController();
  final ScrollController _publicScrollController = ScrollController();
  final ScrollController _friendScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _publicScrollController.addListener(() {
      if (_publicScrollController.position.pixels >=
          _publicScrollController.position.maxScrollExtent - 20) {
        postPageController.loadmorePublicPosts();
      }
    });
    _friendScrollController.addListener(() {
      if (_friendScrollController.position.pixels >=
          _friendScrollController.position.maxScrollExtent - 20) {
        postPageController.loadmoreFriendPosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.02),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Obx(
              () => AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 0.16),
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
                  return RefreshIndicator(
                    onRefresh: () => postPageController.getPublicPost(),
                    child: ListView.builder(
                      controller: _publicScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: postPageController.publicPosts.length,
                      itemBuilder: (context, index) {
                        final post = postPageController.publicPosts[index];
                        return PostWidget(post: post);
                      },
                    ),
                  );
                }),
                Obx(() {
                  return RefreshIndicator(
                    onRefresh: () => postPageController.getFriendPosts(),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _friendScrollController,
                      itemCount: postPageController.friendPosts.length,
                      itemBuilder: (context, index) {
                        final post = postPageController.friendPosts[index];
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
    );
  }
}

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());
  final ElTooltipController _tooltipController = ElTooltipController();

  final CommentController commentController = Get.put(CommentController());
  final PostController postController = Get.put(PostController());

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        color: Colors.indigo.withOpacity(0.1),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.01,
          ),
          child: ListTile(
            isThreeLine: true,
            leading: InkWell(
              onTap: () {
                Get.to(
                  () => OtherProfilePage(
                    profile: widget.post.profile!,
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
                      "${widget.post.uid}${widget.post.profile!.name}",
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
                        if (widget.post.uid ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          Get.to(
                            () => const ProfilePage(),
                            transition: Transition.rightToLeft,
                          );
                        } else {
                          Get.to(
                            () =>
                                OtherProfilePage(profile: widget.post.profile!),
                            transition: Transition.rightToLeft,
                          );
                        }
                      },
                      child: SizedBox(
                        width: Get.width * 0.45,
                        height: Get.height * 0.03,
                        child: Text(
                          widget.post.profile!.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.post.profile!.gender.toLowerCase() ==
                                    "gender.male"
                                ? Colors.blue
                                : Colors.pink,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: ElTooltip(
                        controller: _tooltipController,
                        showArrow: true,
                        color: Colors.blueGrey.withOpacity(0.8),
                        appearAnimationDuration:
                            const Duration(milliseconds: 300),
                        disappearAnimationDuration:
                            const Duration(milliseconds: 300),
                        position: ElTooltipPosition.bottomEnd,
                        content: widget.post.uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      if (mounted) {
                                        _tooltipController.hide();
                                      }
                                      Get.to(
                                        () => CreatePostPage(
                                          isEditing: true,
                                          post: widget.post,
                                        ),
                                        transition: Transition.rightToLeft,
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
                                      if (mounted) {
                                        try {
                                          _tooltipController.hide();
                                        } catch (_) {}
                                      }
                                      await postController
                                          .deletePost(widget.post.id!);
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      if (mounted) {
                                        try {
                                          _tooltipController.hide();
                                        } catch (_) {}
                                      }
                                      await postController
                                          .hidePost(widget.post);
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
                                    onPressed: () {
                                      if (mounted) {
                                        try {
                                          _tooltipController.hide();
                                        } catch (_) {}
                                      }
                                      showReportBottomSheet(widget.post);
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Get.width * 0.1,
                      decoration: BoxDecoration(
                        color: widget.post.profile!.gender.toLowerCase() ==
                                "gender.male"
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.post.profile!.gender.toLowerCase() ==
                                    "gender.male"
                                ? Icons.male
                                : Icons.female,
                            size: 15,
                            color: widget.post.profile!.gender.toLowerCase() ==
                                    "gender.male"
                                ? Colors.blue
                                : Colors.pink,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.post.profile!.age.toString(),
                            style: TextStyle(
                              fontSize: Get.width * 0.025,
                              color:
                                  widget.post.profile!.gender.toLowerCase() ==
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
                        widget.post.createdAt,
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
                    widget.post.body.trim(),
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
                      stream: postController.getLikeStream(widget.post),
                      builder: (context, snapshot) {
                        // snapshot.data as List<String?>;
                        final likes = snapshot.data as List<String>? ?? [];

                        return Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                likes.contains(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                if (likes.contains(
                                    FirebaseAuth.instance.currentUser!.uid)) {
                                  await postController.unlikePost(widget.post);
                                } else {
                                  await postController.likePost(widget.post);
                                }
                              },
                            ),
                            SizedBox(
                              width: Get.width * 0.03,
                              child: Text(
                                likes.isEmpty
                                    ? ""
                                    : snapshot.data != null
                                        ? likes.length.toString()
                                        : "0",
                                style: TextStyle(
                                  fontSize: Get.width * 0.03,
                                ),
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
                            print("Icon Button Pressed");
                            Get.to(
                              () => PostDetailPage(
                                postData: widget.post,
                                profileData: widget.post.profile!,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          icon: const Icon(CupertinoIcons.chat_bubble_2),
                        ),
                        // SizedBox(width: Get.width * 0.05),
                        FutureBuilder(
                          future: commentController.getComments(widget.post),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: Get.width * 0.025,
                                    color: Colors.grey[600],
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}
