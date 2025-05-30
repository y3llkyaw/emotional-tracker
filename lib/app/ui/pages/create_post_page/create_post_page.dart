import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    Key? key,
    this.isEditing = false,
    this.post,
  }) : super(key: key);

  final bool isEditing;
  final Post? post;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final createPostPageController = Get.put(PostController());
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController bodyController = TextEditingController();
  @override
  void initState() {
    bodyController.text = widget.isEditing ? widget.post!.body : "";
    super.initState();
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.isEditing ? "Editing Post" : "Create Post"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: AvatarPlus(
                      "${user.uid}${user.displayName}",
                      // size: 50,
                    ),
                  ),
                  title: Text(user.displayName ?? "User"),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(DateTime.now().toString().split(" ")[0]),
                    ],
                  ),
                  trailing: Obx(
                    () => SizedBox(
                      width: Get.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: createPostPageController
                                    .body.value.isEmpty
                                ? null
                                : () async {
                                    await createPostPageController.createPost();
                                    // Get.back();
                                  },
                            child: Text(
                              widget.isEditing ? "Update" : "Post",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.001),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: TextField(
                    controller: bodyController,
                    onChanged: (value) {
                      value = widget.isEditing ? widget.post!.body : value;
                      createPostPageController.body.value = value;
                    },
                    maxLines: 25,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}
