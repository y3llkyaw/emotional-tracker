import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showShareSheet(String jid) {
  Get.bottomSheet(
    Padding(
      padding: EdgeInsets.all(Get.width * 0.08),
      child: Column(
        children: [
          Text(
            "Share Your Emotions with",
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          SizedBox(
            height: Get.height * 0.38,
            child: Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          Get.width * 0.02,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black)),
                        child: CircleAvatar(
                          radius: 30,
                          child: AvatarPlus("fasdf"),
                        ),
                      ),
                      Text(
                        "Yell Htet Kyaw",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Get.width * 0.03,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: Get.width * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: null,
                  label: const Text(
                    "Send",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.paperplane_fill,
                  ),
                  style: ButtonStyle(
                    iconColor: WidgetStateProperty.all(Colors.white),
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
    elevation: 1,
    backgroundColor: Colors.white,
    enableDrag: true,
  );
}
