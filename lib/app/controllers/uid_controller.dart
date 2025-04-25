import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UidController extends GetxController {
  final fireStore = FirebaseFirestore.instance;
  var cuid = FirebaseAuth.instance.currentUser!.uid.toString().obs;
  var username = "".obs;
  var otherUsername = "".obs;
  var hasUserName = false.obs;
  var isValidUserName = false.obs;
  var statusMessage = "".obs;
  var isLoading = false.obs;
  // late final RxString cuid;

  @override
  void onInit() async {
    super.onInit();
    log("uid-controller init");
    await getCurrentUserUid(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<String?> getUsernameByUid(String uid) async {
    try {
      final doc = await fireStore.collection('usernames').doc(uid).get();
      if (doc.exists) {
        final fetchedUsername = doc.data()?["username"];
        if (fetchedUsername != null) {
          otherUsername.value = fetchedUsername;
          return fetchedUsername;
        }
      }
    } catch (e) {
      log(e.toString(), name: "getUsernameByUid_error");
    }

    otherUsername.value = "";
    return null;
  }

  Future<String?> getCurrentUserUid(String uid) async {
    await fireStore.collection("usernames").doc(uid).get().then((v) {
      if (v.exists) {
        username.value = v.data()!['username'].toString();
        hasUserName.value = true;
        isValidUserName.value = true;
        return v.data();
      } else {
        hasUserName.value = false;
        isValidUserName.value = false;
        return null;
      }
    });
    return null;
  }

  Future<bool> validateUsername(String username) async {
    final validUsername = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validUsername.hasMatch(username)) {
      isValidUserName.value = false;
      statusMessage.value = 'Username can only contain letters and numbers';
      return false;
    }

    final snapshot = await fireStore
        .collection("usernames")
        .where("username", isEqualTo: username)
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        if (doc.data()["uid"] == FirebaseAuth.instance.currentUser!.uid) {
          isValidUserName.value = true;
          statusMessage.value = 'This username is available';
          return true;
        }
      }
      isValidUserName.value = false;
      statusMessage.value = 'Username already taken';
      return false;
    }

    isValidUserName.value = true;
    statusMessage.value = 'This username is available';
    return true;
  }

  Future<void> updateUserName(String username) async {
    try {
      isLoading.value = true;
      if (await validateUsername(username)) {
        await fireStore.collection("usernames").doc(cuid.value).set({
          "uid": cuid.value,
          "username": username,
        });
      }
      Get.back();
      Get.snackbar(
        "Username Updated",
        "Username has been successfully updated",
      );
    } catch (e) {
      log(e.toString(), error: e);
    } finally {
      isLoading.value = true;
    }
  }
}
