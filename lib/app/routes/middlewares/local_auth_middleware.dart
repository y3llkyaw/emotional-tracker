import 'package:emotion_tracker/app/controllers/local_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isEnabled = box.read('localAuth') ?? false;
    final isVerified = box.read('local-auth-verified') ?? false;
    if (isVerified) {
      box.write('local-auth-verified', false);
      return null; // Proceed to the intended route
    }
    if (isEnabled) {
      return const RouteSettings(name: '/local-auth');
    }
    return null; // Proceed to the intended route
  }
}
