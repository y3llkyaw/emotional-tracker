import 'dart:developer';

import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/pages/create_account_page/register_email_verified_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ProfilePageController profilePageController = ProfilePageController();
  var isLoading = false.obs;

  // Reactive user object
  Rx<User?> firebaseUser = Rx<User?>(null);

  // Initialize the controller and bind the user stream
  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<User?> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled login
        isLoading.value = false;
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await profilePageController.getCurrentUserProfile().then((v) {
        Get.offAllNamed("/home");
      }).onError((error, stacTrace) {
        Get.offAllNamed("/profile/name");
      });
      // Get.snackbar("Success", "Logged in successfully!");
      isLoading.value = false;
      return userCredential.user;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading.value = false;
      return null;
    }
  }

  // Sign In with Email and Password
  Future<void> signInWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((v) {
        Get.snackbar("Success", "Logged in successfully!");
        Get.offAllNamed("/home");
      }).onError((e, stacktrace) {
        // Firebase error handling
        String errorMessage = "An unknown error occurred.";

        // Handle specific Firebase errors
        if (e is FirebaseAuthException) {
          log(e.code);
          switch (e.code) {
            case 'invalid-credential':
              errorMessage = "Email or Password is incorrect!";
              break;
            case 'user-not-found':
              errorMessage = "No user found with this email.";
              break;
            case 'wrong-password':
              errorMessage = "Incorrect password. Please try again.";
              break;
            case 'invalid-email':
              errorMessage = "The email address is not valid.";
              break;
            case 'user-disabled':
              errorMessage = "This account has been disabled.";
              break;
            case 'too-many-requests':
              errorMessage = "Too many requests. Please try again later.";
              break;
            case 'operation-not-allowed':
              errorMessage = "Email/password sign-in is not enabled.";
              break;
            default:
              errorMessage =
                  e.message ?? "An error occurred. Please try again.";
          }
        } else {
          // Handle any other errors (non-Firebase errors)
          errorMessage = e.toString();
        }
        Get.snackbar("Error", errorMessage);
      });
    } catch (e) {
      // General catch for any unexpected errors
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  // Register with Email and Password
  Future<void> registerWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Get.snackbar("Success", "Account created successfully!");

      Get.offAll(
        () => const RegisterEmailVerifiedPage(),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.snackbar("Success", "Logged out successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
