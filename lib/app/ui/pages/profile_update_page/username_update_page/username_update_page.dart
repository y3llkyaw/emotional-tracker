import 'dart:async';

import 'package:emotion_tracker/app/controllers/uid_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsernameUpdatePage extends StatefulWidget {
  const UsernameUpdatePage({Key? key}) : super(key: key);

  @override
  State<UsernameUpdatePage> createState() => _UsernameUpdatePageState();
}

class _UsernameUpdatePageState extends State<UsernameUpdatePage> {
  final usernameController = TextEditingController();
  final UidController uidController = Get.put(UidController());
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    usernameController.text = uidController.username.toString();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () => Column(
            children: [
              const ListTile(
                leading: Icon(CupertinoIcons.doc_person),
                title: Text("Change Username"),
                subtitle: Text("people can find you with your username"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                onChanged: (value) async {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce =
                      Timer(const Duration(milliseconds: 200), () async {
                    await uidController.validateUsername(value.toLowerCase());
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Get.theme.colorScheme.onSurface,
                      width: 2,
                    ),
                  ),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
                  hintText: 'Enter your username (letters and numbers only)',
                  helperText: uidController.statusMessage.value,
                  suffixIcon: !uidController.isValidUserName.value
                      ? const Icon(
                          Icons.error_rounded,
                          color: Colors.redAccent,
                        )
                      : const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                  helperStyle: TextStyle(
                    color: uidController.isValidUserName.value
                        ? Colors.green
                        : Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              CustomButton(
                text: "change username",
                onPressed: () {
                  uidController.updateUserName(usernameController.text);
                },
                isDisabled: !uidController.isValidUserName.value,
                isLoading: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
