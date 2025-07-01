// ignore_for_file: constant_identifier_names
class AppRoutes {
  // Home Middlware
  static const INITIAL = '/';
  static const HOME = '/home';
  static const CALENDAR = '/calendar';
  static const ADD_FRIENDS = '/add-friends';

  // Profile Middlware
  static const PROFILE_NAME = '/profile/name';
  static const PROFILE_EDIT = '/profile/edit';
  static const PROFILE_EDIT_PASSWORD = '/profile/update/password';
  static const PROFILE_EDIT_NAME = '/profile/update/name';
  static const PROFILE_EDIT_EMAIL = '/profile/update/email';
  static const PROFILE_EDIT_BIRTHDAY = '/profile/update/birthday';

// Email Verify Middleware
  static const EMAIL_VERIFY = '/email-verify';

  // Auth Middleware
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const REGISTER_GOOGLE = '/register/google';
  static const REGISTER_EMAIL = '/register/email';

  // alarm
  static const ALARM = '/alarm';

  // local auth
  static const LOCAL_AUTH = '/local-auth';

  // Error
  static const UNKNOWN = '/404';
}
