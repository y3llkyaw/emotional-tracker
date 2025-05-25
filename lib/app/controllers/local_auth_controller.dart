import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

final box = GetStorage();

class LocalAuthController extends GetxController {
  var isEnabled = false.obs;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void onInit() {
    isEnabled.value = box.read('localAuth') ?? false;
    super.onInit();
  }

  void toggleLocalAuth() async {
    bool didAuthenticate = await authenticate();
    if (didAuthenticate) {
      isEnabled.value = !isEnabled.value;
      box.write('localAuth', isEnabled.value);
    }
  }

  Future<bool> isBiometricAvailable() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to open the app',
        options: const AuthenticationOptions(
          biometricOnly: false, // Set to false to allow device PIN as fallback
          stickyAuth: true, // Keeps authentication active
        ),
      );
      return didAuthenticate;
    } catch (e) {
      log('Error using biometric authentication: $e');
      return false;
    }
  }
}
