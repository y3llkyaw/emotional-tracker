import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final displayName = FirebaseAuth.instance.currentUser!.displayName;
    final avatar = "$uid$displayName";

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        actions: [
          const Icon(Icons.more_horiz),
          SizedBox(
            width: Get.width * 0.05,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: Get.width * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: Get.width * 0.09,
                      bottom: Get.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.displayName ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.04,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        SizedBox(
                          height: Get.width * 0.5,
                          child: PrettyQrView.data(
                            data: avatar,
                            decoration: const PrettyQrDecoration(
                              background: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const Text("Scan this QR code to add friend."),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Text(
                          "MoodMate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.04,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: "profile_$uid",
                    child: Transform(
                      transform:
                          Matrix4.translationValues(0, -Get.height * 0.05, 0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Get.width * 0.11,
                        child: AvatarPlus(
                          avatar,
                          width: Get.width * 0.21,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
