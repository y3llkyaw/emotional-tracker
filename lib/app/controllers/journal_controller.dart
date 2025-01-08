import 'dart:developer';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalController extends GetxController {
  var isLoading = false.obs;
  var journals = <Journal>[].obs;
  var formatCalender = CalendarFormat.month.obs;
  // Data for the journal

  var content = ''.obs;
  var date = DateTime.now().obs;
  Rx<AnimatedEmojiData> emotion = AnimatedEmojis.neutralFace.obs;

  Future<String?> createJournal() async {
    isLoading.value = true;
    // Save journal to Firestore
    try {
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc("journal_${date.value}")
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "date": date.value,
        "content": content.value,
        "emotion": emotion.value.id.toString(),
      });
      isLoading.value = false;
      fetchJournals();
      return "journal_${date.value}";
      // Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading.value = false;
      return null;
    }
  }

  toggleCalendarFormat() {
    formatCalender.value = formatCalender.value == CalendarFormat.week
        ? CalendarFormat.month
        : CalendarFormat.week;
  }

  Future<void> getJournal(DateTime date) async {
    // Fetch journal from Firestore

    try {
      final journal = await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc("journal_${date.toString()}")
          .get();
      if (journal.exists) {
        final journalData = journal.data()!;
        content.value = journalData["content"];
        emotion.value = AnimatedEmojis.values.firstWhere(
          (emoji) => emoji.id.toString() == journalData["emotion"],
          orElse: () => AnimatedEmojis.neutralFace,
        );
        log(journalData.toString());
      } else {
        log("Journal not found for the given date.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> fetchJournals() async {
    log("fetch-journal", name: "journal-controller");
    try {
      final journalCollection = await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .get();

      journals.value = journalCollection.docs
          .map((journal) => Journal.fromDocument(journal.data()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    update();
  }

  Future<void> deleteJournal(String journalId) async {
    try {
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc(journalId)
          .delete();
      Get.snackbar("Success", "Journal deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
