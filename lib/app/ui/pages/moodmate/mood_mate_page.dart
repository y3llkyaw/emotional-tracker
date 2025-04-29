import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodMatePage extends StatelessWidget {
  const MoodMatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              Text(
                "MoodMate",
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: Get.width * 0.03),
              const Icon(CupertinoIcons.heart_fill)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                showDatingFilterSheet();
              },
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.transparent,
              child: Card(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error,
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 1, // Blur radius
                        offset: const Offset(0, 0), // Offset
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(Get.width * 0.005),
                  width: Get.width * 0.8,
                  height: Get.height * 0.1,
                  // color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Get.width * 0.2,
                        child: SvgPicture.asset("assets/icons/logo.svg"),
                      ),
                      SizedBox(
                        width: Get.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Find your moodmate",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Online Users -",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.03,
                                ),
                                Text(
                                  "10",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: 2, // Number of pages
              controller: PageController(
                  viewportFraction: 0.9), // Optional: for nice partial views
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.error.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0
                                ? Icons.public
                                : CupertinoIcons.person_3_fill,
                            // color: Colors.grey.shade300,
                            color: Get.theme.colorScheme.onSurface,
                          ),
                          SizedBox(width: Get.width * 0.02),
                          Text(
                            index == 0 ? "Public Callouts" : "Friends Callouts",
                            style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Get.theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      SizedBox(
                        height: Get.height * 0.55,
                        width: Get.width *
                            0.8, // Adjust height based on your layout
                        child: ListView.builder(
                          itemCount: 7, // example count
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    child: AvatarPlus("string"),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.03,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: Get.width * 0.55,
                                    decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.error,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "I'm so bored.... yar yar sa ssas kwr",
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      CupertinoIcons.heart,
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // return ListTile(
                            //   title: Row(
                            //     children: [
                            //       CircleAvatar(
                            //         child: AvatarPlus("hello"),
                            //       ),
                            //       SizedBox(
                            //         width: Get.width * 0.03,
                            //       ),
                            //       Text("Yell Htet Kyaws $index"),
                            //       SizedBox(
                            //         width: Get.width * 0.03,
                            //       ),
                            //     ],
                            //   ),
                            //   subtitle: const Text(
                            //       "\nHello HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello HelloHelloHelloHello HelloHelloHelloHelloHello"),
                            //   trailing: Column(
                            //     children: [
                            //       IconButton(
                            //         onPressed: () {},
                            //         icon: const Icon(
                            //           CupertinoIcons.heart,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
