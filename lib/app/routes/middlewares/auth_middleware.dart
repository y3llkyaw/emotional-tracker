import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated;
    if (FirebaseAuth.instance.currentUser != null) {
      isAuthenticated = true;
    } else {
      isAuthenticated = false;
    }
    if (!isAuthenticated) {
      return const RouteSettings(name: '/');
    }
    if (!isAuthenticated) {
      return const RouteSettings(name: '/');
    }
    return null; // Proceed to the intended route
  }
}
