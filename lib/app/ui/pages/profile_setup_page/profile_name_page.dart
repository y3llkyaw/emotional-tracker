import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_setup_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:get/get.dart';

class ProfileNamePage extends StatefulWidget {
  const ProfileNamePage({Key? key}) : super(key: key);

  @override
  State<ProfileNamePage> createState() => _ProfileNamePageState();
}

class _ProfileNamePageState extends State<ProfileNamePage> {
  final ProfileSetupController profileSetupController = Get.find();
  final ProfilePageController profilePageController = ProfilePageController();

  final nameController = TextEditingController();
  final DropdownController<int> dayController = DropdownController();
  final DropdownController<int> monthController = DropdownController();
  final DropdownController<int> yearController = DropdownController();
  var gender = Gender.Male;

  // Generate lists for days, months, and years
  final List<Map<String, dynamic>> days = List.generate(
    31,
    (index) =>
        {"label": "${index + 1}".padLeft(2, '0'), "value": "${index + 1}"},
  );

  final List<Map<String, dynamic>> months = [
    {"label": "January", "value": "01"},
    {"label": "February", "value": "02"},
    {"label": "March", "value": "03"},
    {"label": "April", "value": "04"},
    {"label": "May", "value": "05"},
    {"label": "June", "value": "06"},
    {"label": "July", "value": "07"},
    {"label": "August", "value": "08"},
    {"label": "September", "value": "09"},
    {"label": "October", "value": "10"},
    {"label": "November", "value": "11"},
    {"label": "December", "value": "12"},
  ];

  final List<Map<String, dynamic>> years = List.generate(
    100,
    (index) => {
      "label": "${DateTime.now().year - index}",
      "value": "${DateTime.now().year - index}"
    },
  );

  @override

  /// Clean up the used resources.
  ///
  /// This method is called when this object is removed from the tree permanently.
  /// It is not called when the object is moved to another location in the tree.
  ///
  /// It is safe to call [dispose] multiple times.
  void dispose() {
    super.dispose();
    nameController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06,
            // vertical: Get.height * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // title goes here
              Center(
                child: Text(
                  'Tell me about yourself ?',
                  style: TextStyle(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Name, Genders, Date of Birth. That information will help us better understand you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.size.width * 0.03,
                  ),
                ),
              ),
              // Image goes here
              Center(
                child: SizedBox(
                  height: Get.height * 0.17,
                  child:
                      SvgPicture.asset('assets/image/undraw_profile-data.svg'),
                ),
              ),
              Center(
                child: GenderPickerWithImage(
                  onChanged: (value) {
                    profileSetupController.gender.value = value!;
                  },
                  selectedGender: gender,
                  selectedGenderTextStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  unSelectedGenderTextStyle: const TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  equallyAligned: true,
                  showOtherGender: false,
                ),
              ),
              // textfield goes here
              FormContainerWidget(
                hintText: "Your Name",
                controller: nameController,
              ),
              SafeArea(
                child: DropdownDatePicker(
                  dateformatorder: OrderFormat.YDM, // default is myd
                  inputDecoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  isDropdownHideUnderline: true,
                  isFormValidator: true,
                  startYear: 1900,
                  endYear: 2020,
                  width: 10,
                  selectedDay: 14,
                  selectedMonth: 10,
                  selectedYear: 1993,
                  onChangedDay: (value) => profileSetupController.day.value =
                      int.parse(value.toString()),
                  onChangedMonth: (value) => profileSetupController
                      .month.value = int.parse(value.toString()),
                  onChangedYear: (value) => profileSetupController.year.value =
                      int.parse(value.toString()),
                  boxDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  showDay: true,
                  dayFlex: 2,
                  hintDay: 'Day',
                  hintMonth: 'Month',
                  hintYear: 'Year',
                  hintTextStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              Obx(
                () => CustomButton(
                  text: "Continue",
                  isDisabled: false,
                  isLoading: profileSetupController.loading.value,
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        nameController.text == "") {
                      Get.snackbar("Error", "Please enter your name");
                      return;
                    } else {
                      profileSetupController.name.value = nameController.text;
                      await profileSetupController.setupProfile();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
