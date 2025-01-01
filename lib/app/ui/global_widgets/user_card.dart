import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.26,
      padding: EdgeInsets.symmetric(
        vertical: Get.width * 0.03,
        horizontal: Get.width * 0.01,
      ),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor, // Background color
        borderRadius: BorderRadius.circular(24.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 0), // Offset
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.width * 0.2,
            child: AvatarPlus("hello"),
          ),
          SizedBox(
            height: Get.width * 0.03,
          ),
          Text(
            'Eaint Thet Paing Hmue Khin',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: Get.width * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
