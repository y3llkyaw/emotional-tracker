import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/add_friends_qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final displayName = FirebaseAuth.instance.currentUser!.displayName;
    final avatar = "$uid$displayName";

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? const Color.fromARGB(255, 66, 37, 0)
          : Colors.amberAccent,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? const Color.fromARGB(255, 66, 37, 0)
            : Colors.amberAccent,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => QRScannerPage());
            },
            label: Text(
              "scan QR code",
              style: TextStyle(
                color: Get.theme.colorScheme.secondary,
              ),
            ),
            icon: Icon(
              Icons.qr_code_scanner,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
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
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.grey : Colors.white,
                      borderRadius: const BorderRadius.all(
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
                            data: uid,
                            decoration: PrettyQrDecoration(
                              background:
                                  Get.isDarkMode ? Colors.grey : Colors.white,
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
                        backgroundColor:
                            Get.isDarkMode ? Colors.grey : Colors.white,
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
