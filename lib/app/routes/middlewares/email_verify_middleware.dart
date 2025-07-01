import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class EmailVerifyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isEmailVerified;
    if (FirebaseAuth.instance.currentUser != null) {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    } else {
      isEmailVerified = false;
    }
    if (!isEmailVerified) {
      return const RouteSettings(name: '/email-verify');
    }
    return null;
  }
}
