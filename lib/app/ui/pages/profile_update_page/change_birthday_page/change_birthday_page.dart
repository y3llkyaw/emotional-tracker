import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_setup_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeBirthdayPage extends StatefulWidget {
  const ChangeBirthdayPage({Key? key, required this.birthday})
      : super(key: key);
  final DateTime birthday;

  @override
  State<ChangeBirthdayPage> createState() => _ChangeBirthdayPageState();
}

class _ChangeBirthdayPageState extends State<ChangeBirthdayPage> {
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  final ProfilePageController profilePageController = ProfilePageController();
  final ProfileSetupController profileSetupController =
      ProfileSetupController();
  @override
  void initState() {
    super.initState();
    setState(() {
      day.text = widget.birthday.day.toString();
      month.text = widget.birthday.month.toString();
      year.text = widget.birthday.year.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ListTile(
              leading: Icon(Icons.cake),
              title: Text(
                "Change Your Birthday",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text("your birthday date will not be shown"),
            ),
            CalendarDatePicker(
              initialDate: widget.birthday,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onDateChanged: (DateTime value) {
                setState(() {
                  day.text = value.day.toString();
                  month.text = value.month.toString();
                  year.text = value.year.toString();
                });
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Obx(
              () => CustomButton(
                  isLoading: profilePageController.isLoading.value,
                  text: "Change Birthday",
                  onPressed: () async {
                    final newBirthday = DateTime(
                      int.parse(year.text),
                      int.parse(month.text),
                      int.parse(day.text),
                    );
                    bool isValid =
                        profileSetupController.is16OrOlder(newBirthday);

                    if (isValid) {
                      await profilePageController.updateBirthday(newBirthday);
                    } else {
                      Get.snackbar(
                        "Updating Birthday Fail",
                        "User need to be 16 years old or older",
                      );
                    }
                    // print(newBirthday);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
