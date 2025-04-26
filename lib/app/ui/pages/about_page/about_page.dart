import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Could not open the link.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch phone app.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About MoodMate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SvgPicture.asset("assets/icons/logo.svg"),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'MoodMate',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'MoodMate is an emotion tracking app designed to help users easily record and reflect on their daily emotions, habits, and moods. '
                'It includes features like daily mood tracking, calendar views, friend connections and messaging — '
                'all crafted to create a beautiful and simple mental health journey.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                showLicensePage(context: context);
              },
              child: const Text(
                "Licenses",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Development Team',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _teamMember(
              name: 'Shun Lei Aung',
              role: 'Graphic Designer',
              description: 'Designed the official app logo for MoodMate.',
            ),
            const SizedBox(height: 16),
            _teamMember(
              name: 'Min Thank Phyo',
              role: 'UI/UX Designer',
              linkedIn: "https://www.linkedin.com/in/min-thant-phyo-089911274/",
              description:
                  'Designed intuitive, user-friendly flows and interfaces for the best emotional tracking experience.',
            ),
            const SizedBox(height: 16),
            _teamMember(
              name: 'Yell Htet Kyaw',
              role: 'Developer',
              phone: "+66823876003",
              linkedIn: "https://www.linkedin.com/in/yell-htet-kyaw-bb9a4a214/",
              github: "https://github.com/y3llkyaw",
              description:
                  'Built the full app using Flutter with powerful state management (GetX) and clean architecture.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamMember({
    required String name,
    required String role,
    required String description,
    String? github,
    String? linkedIn,
    String? phone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name — $role',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (linkedIn != null)
                IconButton(
                  onPressed: () => _launchUrl(linkedIn),
                  icon: SvgPicture.asset(
                    "assets/icons/linkedIn.svg",
                    color: Get.theme.colorScheme.onSurface,
                    height: 24,
                  ),
                ),
              if (github != null)
                IconButton(
                  onPressed: () => _launchUrl(github),
                  icon: SvgPicture.asset(
                    "assets/icons/github.svg",
                    color: Get.theme.colorScheme.onSurface,
                    height: 24,
                  ),
                ),
              if (phone != null)
                IconButton(
                  onPressed: () => _makePhoneCall(phone),
                  icon: const Icon(Icons.phone),
                ),
            ],
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}
