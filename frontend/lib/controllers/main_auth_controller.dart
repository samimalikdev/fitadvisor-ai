import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_ai/screens/bottom_nav_bar.dart';
import 'package:nutrition_ai/screens/login_screen.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthUIState {
  var selectedTab = 'login'.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;
  var acceptTerms = false.obs;

  void switchTab(String tab) => selectedTab.value = tab;
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRememberMe() => rememberMe.value = !rememberMe.value;
  void toggleAcceptTerms() => acceptTerms.value = !acceptTerms.value;
}

class AuthFormState {
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var emailFocused = false.obs;
  var passwordFocused = false.obs;
  var nameFocused = false.obs;

  void focusEmailField(bool focused) => emailFocused.value = focused;
  void focusPasswordField(bool focused) => passwordFocused.value = focused;
  void focusNameField(bool focused) => nameFocused.value = focused;
}

class MainAuthController extends GetxController {
  final ui = AuthUIState();
  final form = AuthFormState();
  final ApiController _apiController = ApiController();
  final SharedPrefsService _prefsService = SharedPrefsService();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<void> onLoginPressed() async {
    if (form.loginFormKey.currentState!.validate()) {
      _isLoading.value = true;
      final email = form.emailController.text.trim();
      final password = form.passwordController.text;

      try {
        final result = await _apiController.post('/auth/login', {
          'email': email,
          'password': password,
        });

        if (result != null && result['token'] != null) {
          await _prefsService.saveToken(result['token']);
          Get.offAll(() => BottomNavScreen());
        }
      } catch (e) {
        print("Error login: $e");
        SnackbarHelper.showError("Login Failed", e.toString());
      } finally {
        _isLoading.value = false;
      }
    }
  }

  Future<void> onSignupPressed() async {
    try {
      if (form.signupFormKey.currentState!.validate()) {
        if (form.passwordController.text !=
            form.confirmPasswordController.text) {
          SnackbarHelper.showError(
              "Validation Error", "Passwords do not match.");
          return;
        }
        if (!ui.acceptTerms.value) {
          SnackbarHelper.showError(
              "Validation Error", "Please accept the Terms & Conditions.");
          return;
        }

        _isLoading.value = true;
        final name = form.nameController.text.trim();
        final email = form.emailController.text.trim();
        final password = form.passwordController.text;

        final result = await _apiController.post('/auth/register', {
          'name': name,
          'email': email,
          'password': password,
        });

        if (result != null && result['token'] != null) {
          await _prefsService.saveToken(result['token']);
          Get.offAll(() => BottomNavScreen());
        }
      }
    } catch (e) {
      print('error $e  in signup');
      SnackbarHelper.showError("Registration Failed", e.toString());
    } finally {
      if (_isLoading.value) _isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      _isLoading.value = true;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final result = await _apiController.post('/auth/google', {
          'idToken': idToken,
        });
        if (result != null && result['token'] != null) {
          await _prefsService.saveToken(result['token']);
          Get.offAll(() => BottomNavScreen());
        }
      } else {
        SnackbarHelper.showError(
            "Auth Error", "Could not retrieve Google token");
      }
    } catch (e) {
      print("Google Sign In Error: $e");
      SnackbarHelper.showError("Auth Error", "Failed to sign in with Google.");
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    try {
      _isLoading.value = true;
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? identityToken = credential.identityToken;
      final String? fullName =
          (credential.givenName != null && credential.familyName != null)
              ? "${credential.givenName} ${credential.familyName}"
              : credential.givenName ?? credential.familyName;

      if (identityToken != null) {
        final result = await _apiController.post('/auth/apple', {
          'identityToken': identityToken,
          'fullName': fullName,
        });

        if (result != null && result['token'] != null) {
          await _prefsService.saveToken(result['token']);
          Get.offAll(() => BottomNavScreen());
        }
      } else {
        SnackbarHelper.showError(
            "Auth Error", "Could not retrieve Apple token");
      }
    } catch (e) {
      print("Apple Sign In Error: $e");

      if (e.toString().contains('Canceled')) return;
      SnackbarHelper.showError("Auth Error", "Failed to sign in with Apple.");
    } finally {
      _isLoading.value = false;
    }
  }

  void loginWithFacebook() {}
}
