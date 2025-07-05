import 'package:cool_dropdown/cool_dropdown.dart';
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

  @override
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
                  size: 60,
                  maleImage: const AssetImage("assets/image/male.png"),
                  femaleImage: const AssetImage("assets/image/female.png"),
                  onChanged: (value) {
                    profileSetupController.gender.value = value!;
                  },
                  selectedGender: gender,
                  selectedGenderTextStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  unSelectedGenderTextStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                  equallyAligned: true,
                  showOtherGender: false,
                ),
              ),
              FormContainerWidget(
                hintText: "Your Name",
                controller: nameController,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      const Text(
                        "Birthday",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  SafeArea(
                    child: DropdownDatePicker(
                      dateformatorder: OrderFormat.YDM, // default is myd
                      inputDecoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
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

                      onChangedDay: (value) => profileSetupController
                          .day.value = int.parse(value.toString()),
                      onChangedMonth: (value) => profileSetupController
                          .month.value = int.parse(value.toString()),
                      onChangedYear: (value) => profileSetupController
                          .year.value = int.parse(value.toString()),
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
                ],
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
