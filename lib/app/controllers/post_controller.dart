import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final index = 0.obs;
  final post = {}.obs;
  final publicPosts = [].obs;
  final friendPosts = [].obs;
  final myPosts = [].obs;

  final isLoading = false.obs;
  final isDeleting = false.obs;
  final body = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getMyPosts();
    getPublicPost();
  }

  final myPostsRef = FirebaseFirestore.instance
      .collection("posts")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("createdAt", descending: true);
  final pubPostsRef = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("createdAt", descending: true);

  Future<void> getMyPosts() async {
    isLoading.value = true;
    await myPostsRef.get().then((value) {
      myPosts.value = value.docs.map((e) => Post.fromJson(e.data())).toList();
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  Future<void> getPublicPost() async {
    isLoading.value = true;
    await pubPostsRef.get().then((value) {
      publicPosts.value =
          value.docs.map((e) => Post.fromJson(e.data())).toList();
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  Future<void> createPost() async {
    isLoading.value = true;
    final newPost = Post(
      uid: FirebaseAuth.instance.currentUser!.uid,
      body: body.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      type: "text",
    );
    await FirebaseFirestore.instance
        .collection("posts")
        .add(newPost.toJson())
        .then((value) async {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(value.id)
          .update({
        "id": value.id,
      }).then((value) {
        Get.snackbar("Success", "Post created successfully");
      });
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  void deletePost(String postId) async {
    isDeleting.value = true;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .then((value) {
      Get.snackbar("Success", "Post deleted successfully");
      isDeleting.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isDeleting.value = false;
    });
  }
}
