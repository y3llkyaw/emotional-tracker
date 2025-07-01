import 'dart:developer';

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

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    // Perform tasks before the page builds (e.g., logging)
    log("Page is about to build: ${page.runtimeType}", name: "auth-middleware");
    return super.onPageBuildStart(page);
  }

  @override
  Widget onPageBuilt(Widget page) {
    // Modify the page widget after it's built
    log("Page built: ${page.runtimeType}", name: "auth-middleware");
    return super.onPageBuilt(page);
  }

  @override
  void onPageDispose() {
    // Cleanup when the page is disposed
    log("Page is disposed", name: "auth-middleware");
    super.onPageDispose();
  }
}
