import 'package:emotion_tracker/app/bindings/login_binding.dart';
import 'package:emotion_tracker/app/bindings/register_binding.dart';
import 'package:emotion_tracker/app/routes/middlewares/auth_middleware.dart';
import 'package:emotion_tracker/app/routes/middlewares/profile_middleware.dart';
import 'package:emotion_tracker/app/ui/pages/create_account_page/create_account_page.dart';
import 'package:emotion_tracker/app/ui/pages/create_account_page/register_email_page.dart';
import 'package:emotion_tracker/app/ui/pages/landing_page/landing_page.dart';
import 'package:emotion_tracker/app/ui/pages/login_page/login_page.dart';
import 'package:emotion_tracker/app/ui/pages/profile_setup_page/profile_name_page.dart';
import 'package:get/get.dart';

import '../bindings/home_binding.dart';
import '../ui/pages/home_page/home_page.dart';
import '../ui/pages/unknown_route_page/unknown_route_page.dart';
import 'app_routes.dart';

const _defaultTransition = Transition.size;
const defaultTransitionDuration = Duration(milliseconds: 500);

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => const UnknownRoutePage(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const LandingPage(),
      // binding: HomeBinding(),
      transitionDuration: defaultTransitionDuration,
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
      middlewares: [
        AuthMiddleware(),
        ProfileMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const CreateAccountPage(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.REGISTER_EMAIL,
      page: () => const RegisterEmailPage(),
      binding: RegisterBinding(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.PROFILE_NAME,
      page: () => ProfileNamePage(),
      // binding: RegisterBinding(),
      transition: _defaultTransition,
      transitionDuration: defaultTransitionDuration,
    ),
  ];
}
