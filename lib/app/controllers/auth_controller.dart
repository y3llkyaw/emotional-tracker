import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive user object
  Rx<User?> firebaseUser = Rx<User?>(null);

  // Initialize the controller and bind the user stream
  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Sign In with Email and Password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged in successfully!");
      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Register with Email and Password
  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar("Success", "Account created successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
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
