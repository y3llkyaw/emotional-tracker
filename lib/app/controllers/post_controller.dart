import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final index = 0.obs;
  final post = {}.obs;
  final publicPosts = [].obs;
  final friendPosts = [].obs;
  final myPosts = [].obs;

  final selectedReportType = Rx<ReportType?>(ReportType.spam);
  final reportBody = ''.obs;
  final isLoading = false.obs;
  final isDeleting = false.obs;
  final body = ''.obs;

  final friendController = Get.put(FriendsController());
  final notiController = Get.put(NotiController());
  var friends = <String>[].obs;

  late DocumentSnapshot? lastPublicPostDoc;
  late DocumentSnapshot? lastFriendPostDoc;

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
      .orderBy("createdAt", descending: true)
      .limit(30);

  Query<Map<String, dynamic>> get friPostsRef => FirebaseFirestore.instance
      .collection("posts")
      .where("uid", whereIn: friends)
      .orderBy("createdAt", descending: true)
      .limit(30);

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
    if (friends.isEmpty) {
      friendPosts.value = [];
      isLoading.value = false;
      return;
    }
    await friPostsRef.get().then((value) async {
      final posts = await Future.wait(value.docs.map((e) async {
        var post = Post.fromJson(e.data());
        Profile profile = await profilePageController.getProfileByUid(post.uid);
        post.profile = profile;
        return post;
      }));
      friendPosts.value = posts;
      if (value.docs.isNotEmpty) {
        lastFriendPostDoc = value.docs.last;
      }
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  loadmoreFriendPosts() async {
    isLoading.value = true;
    if (lastFriendPostDoc == null) {
      isLoading.value = false;
      return;
    }
    await friPostsRef
        .startAfterDocument(lastFriendPostDoc!)
        .limit(30)
        .get()
        .then((value) async {
      final posts = await Future.wait(value.docs.map((e) async {
        var post = Post.fromJson(e.data());
        Profile profile = await profilePageController.getProfileByUid(post.uid);
        post.profile = profile;
        return post;
      }));
      friendPosts.addAll(posts);
      isLoading.value = false;
    }).onError((error, stackTrace) {
      // Get.snackbar("Error", error.toString());
      log("Error loading more friend posts: $error");
      isLoading.value = false;
    });
  }

  Future<void> getPublicPost() async {
    isLoading.value = true;
    await pubPostsRef.get().then((value) async {
      final posts = await Future.wait(value.docs.map((e) async {
        var post = Post.fromJson(e.data());
        Profile profile = await profilePageController.getProfileByUid(post.uid);
        post.profile = profile;
        return post;
      }));
      publicPosts.value = posts;
      if (value.docs.isNotEmpty) {
        lastPublicPostDoc = value.docs.last;
      }
      isLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
      isLoading.value = false;
    });
  }

  loadmorePublicPosts() async {
    if (isLoading.value) return;
    isLoading.value = true;
    if (lastFriendPostDoc == null) {
      isLoading.value = false;
      return;
    }
    await pubPostsRef
        .startAfterDocument(lastPublicPostDoc!)
        .limit(30)
        .get()
        .then((value) async {
      final posts = await Future.wait(value.docs.map((e) async {
        var post = Post.fromJson(e.data());
        Profile profile = await profilePageController.getProfileByUid(post.uid);
        post.profile = profile;
        return post;
      }));
      publicPosts.addAll(posts);
      if (value.docs.isNotEmpty) {
        lastPublicPostDoc = value.docs.last;
      }
      isLoading.value = false;
    }).onError((error, stackTrace) {
      log("Error loading more friend posts: $error");
      isLoading.value = false;
    });
  }

  Future<Post?> getPostById(String pid) async {
    final result =
        await FirebaseFirestore.instance.collection("posts").doc(pid).get();
    if (result.exists) {
      return Post.fromJson(result.data()!);
    }
    return null;
  }

  Future<void> updatePost(Post post) async {
    log("Updating post: ${post.id}");
    log("Body: ${body.value}");
    isLoading.value = true;
    final updatedPost = Post(
      id: post.id,
      uid: post.uid,
      body: body.value,
      createdAt: post.createdAt,
      updatedAt: DateTime.now(),
      type: post.type,
      imageUrl: post.imageUrl,
    );
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .update(updatedPost.toJson())
        .then((value) {
      Get.back();
      Get.snackbar("Success", "Post updated successfully");
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
      }).then((v) async {
        newPost.id = value.id;
        newPost.profile =
            await profilePageController.getProfileByUid(newPost.uid);
        publicPosts.insert(0, newPost);
        Get.back();
        Get.snackbar(
          "Success",
          "Post added successfully",
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.BOTTOM,
          instantInit: false,
          shouldIconPulse: true,
          maxWidth: Get.width * 0.7,
          duration: const Duration(
            milliseconds: 800,
          ),
        );
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
      Get.snackbar(
        "Success",
        "Post deleted successfully",
        icon: const Icon(Icons.delete, color: Colors.green),
        snackPosition: SnackPosition.BOTTOM,
        instantInit: false,
        shouldIconPulse: true,
        maxWidth: Get.width * 0.7,
        duration: const Duration(
          milliseconds: 800,
        ),
      );
      publicPosts.removeWhere((p) => p.id == postId);
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
    }).then((v) async {
      if (post.uid != uid) {
        await notiController.likePost(post);
      }
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
    }).then((v) async {
      await notiController.unlikePost(post);
    });
    ;
  }

  Future<void> reportPost(Post post) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final reportRef = FirebaseFirestore.instance.collection("reports").doc();
    await reportRef.set({
      "postId": post.id,
      "uid": uid,
      "type": selectedReportType.value.toString(),
      "createdAt": DateTime.now(),
      "reason": reportBody.value,
    }).then((value) {
      reportBody.value = '';
      Get.back();
      Get.snackbar("Success", "Post reported successfully");
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }

  Future<void> reportComment(Post post, Comment comment) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final reportRef = FirebaseFirestore.instance.collection("reports").doc();
    await reportRef.set({
      "commentId": comment.id, // Assuming post.id is the comment ID
      "postId": post.id,
      "uid": uid,
      "type": selectedReportType.value.toString(),
      "createdAt": DateTime.now(),
      "reason": reportBody.value,
    }).then((value) {
      reportBody.value = '';
      Get.back();
      Get.snackbar("Success", "Post reported successfully");
    }).onError((error, stackTrace) {
      Get.snackbar("Error", error.toString());
    });
  }
}
