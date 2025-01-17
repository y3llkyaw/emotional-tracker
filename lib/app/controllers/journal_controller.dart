import 'dart:developer';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/mood_slider_controller.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalController extends GetxController {
  final moodsliderController = MoodSliderController();
  var indexDataJournal = 0.obs;
  var isLoading = false.obs;
  var journals = <Journal>[].obs;
  var formatCalender = CalendarFormat.month.obs;
  var singleJournal = Rxn<Journal>();
  var moodSlider = 2.obs;

  var content = ''.obs;
  var date = DateTime.now().obs;
  Rx<AnimatedEmojiData> emotion = AnimatedEmojis.neutralFace.obs;

  void previousPage() {
    log(indexDataJournal.value.toString());
    indexDataJournal.value != 0 ? indexDataJournal.value -= 1 : null;
  }

  void nextPage() {
    log(indexDataJournal.value.toString());
    indexDataJournal.value < journals.length - 1
        ? indexDataJournal.value += 1
        : null;
  }

  Future<String?> createJournal() async {
    isLoading.value = true;
    // Save journal to Firestore
    try {
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc("journal_${date.value.toString().split(" ")[0]}")
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "date": date.value,
        "content": content.value,
        "emotion": emotion.value.id.toString(),
        "value": moodSlider.value,
      }).then((value) {
        Get.back();
        Get.snackbar("Success", "Journal Created Successfully..");
      });
      isLoading.value = false;
      fetchJournals();
      return "journal_${date.value}";
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
    log("get journal");
    print("date $date");
    try {
      final journal = await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc("journal_${date.toString().split(" ")[0]}")
          .get();
      if (journal.exists) {
        final journalData = journal.data()!;
        content.value = journalData["content"];
        emotion.value = AnimatedEmojis.values.firstWhere(
          (emoji) => emoji.id.toString() == journalData["emotion"],
          orElse: () => AnimatedEmojis.neutralFace,
        );
        singleJournal.value = Journal.fromDocument(journalData);
      } else {
        log("Journal not found for the given date.");
      }
    } catch (e) {
      log(e.toString());
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
      // print(journalId);
      await FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("journals")
          .doc("journal_${journalId.toString().split(" ")[0]}")
          .delete()
          .then((v) {
        Get.back();
        Get.snackbar("Success", "Journal deleted successfully!");
      });
      fetchJournals();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
