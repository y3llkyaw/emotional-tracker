import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerifyController extends GetxController {
  // Reactive email verification status
  RxBool isEmailVerified =
      (FirebaseAuth.instance.currentUser?.emailVerified ?? false).obs;
  Timer? _timer;
  Timer? _resendTimer;
  RxInt resendCooldown = 60.obs;

  @override
  void onInit() {
    super.onInit();
    // Start polling for email verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      isEmailVerified.value =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
    _startResendCooldown();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    resendCooldown.value = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification().then((v) {
        Get.snackbar("Verification Email Sent",
            "Please check your email to verify your account.");
        _startResendCooldown();
      }).catchError((e) {
        Get.snackbar("Error", "Failed to send verification email!");
        log(
          e.toString(),
          name: "email-verify-controller",
        );
      });
    }
  }
}
