import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:get/get.dart';

class ProfileNamePage extends StatefulWidget {
  const ProfileNamePage({Key? key}) : super(key: key);

  @override
  State<ProfileNamePage> createState() => _ProfileNamePageState();
}

class _ProfileNamePageState extends State<ProfileNamePage> {
  final nameController = TextEditingController();
  final DropdownController<String> dayController = DropdownController();
  final DropdownController<String> monthController = DropdownController();
  final DropdownController<String> yearController = DropdownController();

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
  var gender = Gender.Male;
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
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // title goes here
              const Center(
                child: Text(
                  'Tell me about yourself ?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Name, Genders, Date of Birth. That information will help us better understand you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Get.size.height / 60,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Image goes here
              Center(
                child: Image(
                  image: const AssetImage('assets/image/detective.png'),
                  height: Get.height / 4,
                  width: Get.width / 2,
                ),
              ),
              GenderPickerWithImage(
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                selectedGender: gender,
                selectedGenderTextStyle: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                unSelectedGenderTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                equallyAligned: true,
                showOtherGender: true,
              ),

              // textfield goes here
              FormContainerWidget(
                hintText: "Your Name",
                controller: nameController,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: Get.width / 3 - 40,
                    child: CoolDropdown(
                        resultOptions: const ResultOptions(
                          placeholder: "Year",
                        ),
                        dropdownList: years.map((month) {
                          return CoolDropdownItem<String>(
                            label: month["label"],
                            value: month["value"],
                          );
                        }).toList(),
                        controller: DropdownController(),
                        onChange: (value) {}),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 20,
                    child: CoolDropdown(
                        resultOptions: const ResultOptions(
                          placeholder: "Month",
                        ),
                        dropdownList: months.map((month) {
                          return CoolDropdownItem<String>(
                            label: month["label"],
                            value: month["value"],
                          );
                        }).toList(),
                        controller: DropdownController(),
                        onChange: (value) {}),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 20,
                    child: CoolDropdown(
                        resultOptions: const ResultOptions(
                          placeholder: "Date",
                        ),
                        dropdownList: List.generate(
                            31,
                            (index) => CoolDropdownItem(
                                  label: (index + 1).toString(),
                                  value: index + 1,
                                )).toList(),
                        controller: DropdownController(),
                        onChange: (value) {}),
                  ),
                ],
              ),

              CustomButton(
                text: "Continue",
                isDisabled: false,
                isLoading: false,
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      nameController.text == "") {
                    Get.snackbar("Error", "Please enter your name");
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
