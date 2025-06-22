import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentController extends GetxController {
  final comment = ''.obs;
  final isLoading = false.obs;
  final commentList = <Comment>[].obs;
  final commentLikes = [].obs;

  final ns = NotificationService();

  final _cuid = FirebaseAuth.instance.currentUser!.uid;

  Future<Comment> getCommentById(Post post, String cid) async {
    try {
      return await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(cid)
          .get()
          .then((value) => Comment.fromJson(value.data() ?? {}));
    } catch (e) {
      log(e.toString(), name: "Error");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(Post post) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'postId': post.id,
        'comment': comment.value,
        'createdAt': Timestamp.now(),
      }).then((value) async {
        final result = await value.get();

        Comment comment = Comment.fromJson(result.data()!);
        comment.id = value.id;
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection("comments")
            .doc(value.id)
            .update({'id': value.id}).then((value) async {
          Fluttertoast.showToast(
            gravity: ToastGravity.TOP,
            msg: "Comment added successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.indigo,
            textColor: Colors.white,
          );
        });

        if (post.uid != _cuid) {
          await ns.commentNoti(post, comment);
        }
      }).onError((error, stackTrace) {
        Get.snackbar("Error", error.toString());
      });
      comment.value = '';
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteComment(Comment comment) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(comment.postId)
          .collection("comments")
          .doc(comment.id)
          .delete()
          .then((value) async {
        final result = await FirebaseFirestore.instance
            .collection("posts")
            .doc(comment.postId)
            .get();

        await ns
            .deleteNoti(result.data()!["uid"],
                "comment_${comment.postId}_${comment.id}")
            .then((value) {
          Fluttertoast.showToast(
            gravity: ToastGravity.TOP,
            msg: "Comment deleted successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.indigo,
            textColor: Colors.white,
          );
        });
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateComment(Post post, String commentId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(commentId)
          .update({
        'body': comment.value,
        'updatedAt': DateTime.now(),
      }).then((value) {
        Get.snackbar("Success", "Comment updated successfully");
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeComment(Post post, Comment comment) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(comment.id)
          .update({
        'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      }).then((value) async {
        if (comment.uid != _cuid) {
          await ns.likeCommentNoti(post, comment);
        }
      }).onError((e, stackTrace) {
        log(e.toString());
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlikeComment(Post post, Comment comment) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(comment.id)
          .update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((value) async {
        ns.deleteNoti(comment.uid, "like_comment_${_cuid}_${comment.id}");
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Comment?>> getComments(Post post) async {
    isLoading.value = true;
    try {
      final comments = await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .orderBy('createdAt', descending: true)
          .get()
          .then((value) {
        return value.docs.map((e) => Comment.fromJson(e.data())).toList();
      });
      commentList.value = comments;
      return comments;
    } catch (e) {
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Stream the likes of a comment in real-time
  Stream<List<String>> commentLikesStream(Post post, String commentId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection("comments")
        .doc(commentId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || data['likes'] == null) return <String>[];
      return List<String>.from(data['likes']);
    });
  }
}
