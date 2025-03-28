import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
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
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await profilePageController.getCurrentUserProfile().then((v) {
        Get.toNamed("/home");
      }).onError((error, stacTrace) {
        Get.toNamed("/profile/name");
      });
      // Get.snackbar("Success", "Logged in successfully!");

      return userCredential.user;
    } catch (e) {
      Get.snackbar("Error", e.toString());

      return null;
    }
  }

  // Sign In with Email and Password
  Future<void> signInWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged in successfully!");
      Get.offAllNamed("/home");
    } catch (e) {
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
      Get.offAllNamed("/home");
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
