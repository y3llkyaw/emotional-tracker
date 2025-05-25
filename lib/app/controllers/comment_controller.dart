import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final comment = ''.obs;
  final isLoading = false.obs;
  final commentList = <Comment>[].obs;

  Future<void> addComment(Post post) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .add({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'comment': comment.value,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.id)
            .collection("comments")
            .doc(value.id)
            .update({'id': value.id}).then((value) async {
          Get.snackbar("Success", "Comment added successfully");
        });
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

  Future<void> deleteComment(Post post, String commentId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(commentId)
          .delete()
          .then((value) {
        Get.snackbar("Success", "Comment deleted successfully");
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

  Future<void> likeComment(Post post, String commentId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      }).then((value) {
        Get.snackbar("Success", "Comment liked successfully");
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlikeComment(Post post, String commentId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection("comments")
          .doc(commentId)
          .update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((value) {
        Get.snackbar("Success", "Comment unliked successfully");
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
}
