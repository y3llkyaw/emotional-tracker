import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
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

  final friendController = Get.put(FriendsController());
  var friends = <String>[].obs;
  @override
  void onInit() async {
    super.onInit();
    await friendController.getFriends().then((v) {
      friends.value =
          friendController.friends.map((e) => e.uid.toString()).toList();
    });

    getMyPosts();
    getFriendPosts();
    getPublicPost();
  }

  final myPostsRef = FirebaseFirestore.instance
      .collection("posts")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("createdAt", descending: true);

  final pubPostsRef = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("createdAt", descending: true);

  Query<Map<String, dynamic>> get friPostsRef => FirebaseFirestore.instance
      .collection("posts")
      .where("uid", whereIn: friends)
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

  Future<void> getFriendPosts() async {
    isLoading.value = true;
    await friPostsRef.get().then((value) {
      friendPosts.value =
          value.docs.map((e) => Post.fromJson(e.data())).toList();
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
        Get.back();
        Get.snackbar("Success", "Post created successfully");
      });
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  Future<void> deletePost(String postId) async {
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

  Future<void> hidePost(Post post) async {
    isDeleting.value = true;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postRef = FirebaseFirestore.instance
        .collection("profile")
        .doc(uid)
        .collection("posts")
        .doc(post.id);
    await postRef.set({
      "id": post.id,
    }).then((value) {
      isDeleting.value = false;
      publicPosts.removeWhere((p) => p.id == post.id);
      friendPosts.removeWhere((p) => p.id == post.id);
      Get.snackbar("Success", "Post hidden successfully");
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isDeleting.value = false;
    });
  }

  Stream<List<String>> getLikeStream(Post post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()['uid'] as String).toList();
    });
  }

  Future<void> likePost(Post post) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postRef = FirebaseFirestore.instance.collection("posts").doc(post.id);

    await postRef.collection("likes").doc(uid).set({
      "uid": uid,
      // "createdAt": DateTime.now(),
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> unlikePost(Post post) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postRef = FirebaseFirestore.instance.collection("posts").doc(post.id);

    await postRef
        .collection("likes")
        .doc(uid)
        .delete()
        .then((value) {})
        .onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }
}
