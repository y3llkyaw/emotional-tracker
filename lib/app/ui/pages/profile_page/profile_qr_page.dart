import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/ui/pages/friends_pages/add_friends_qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: Get.theme.colorScheme.error,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Get.to(() => const QRScannerPage());
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
                      color: Get.theme.colorScheme.onError,
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
                            color: Colors.black,
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
                              // image: PrettyQrDecorationImage(image: ),
                              background: Get.theme.colorScheme.onError,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        const Text(
                          "Scan this QR code to add friend.",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Get.width * 0.15,
                              width: Get.width * 0.15,
                              child: SvgPicture.asset('assets/icons/logo.svg'),
                            ),
                            Text(
                              "MoodMate",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.width * 0.04,
                                overflow: TextOverflow.fade,
                                color: Colors.black,
                              ),
                            ),
                          ],
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
