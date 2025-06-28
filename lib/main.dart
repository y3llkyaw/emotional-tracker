import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emotion_tracker/app/controllers/darkmode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/dependency_injection.dart';
import 'app/data/services/translations_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/layouts/main/main_layout.dart';
import 'app/ui/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependecyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DarkmodeController darkmodeController = Get.find();
  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _checkInitialConnection();
    _connectivityStream.listen((result) {
      if (result == ConnectivityResult.none) {
        _showNoInternetDialog();
      } else {
        if (Get.isDialogOpen ?? false) Get.back();
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (!(Get.isDialogOpen ?? false)) {
      Get.dialog(
        AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        log('App is in the foreground.');
        break;
      case AppLifecycleState.inactive:
        log('App is inactive.');
        break;
      case AppLifecycleState.hidden:
        log('App is inactive.');
        break;
      case AppLifecycleState.paused:
        log('App is in the background.');
        break;
      case AppLifecycleState.detached:
        log('App is detached.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) {
        return Obx(
          () => GetMaterialApp(
            title: 'MoodMate',
            debugShowCheckedModeBanner: false,
            theme: Themes().lightTheme,
            darkTheme: Themes().darkTheme,
            themeMode: darkmodeController.currentThemeMode,
            translations: Translation(),
            locale: const Locale('en'),
            fallbackLocale: const Locale('en'),
            initialRoute: AppRoutes.HOME,
            unknownRoute: AppPages.unknownRoutePage,
            getPages: AppPages.pages,
            builder: (_, child) {
              return MainLayout(child: child!);
            },
          ),
        );
      },
      //! Must change it to true if you want to use the ScreenUtil
      ensureScreenSize: true,
      designSize: const Size(411, 823),
    );
  }
}
