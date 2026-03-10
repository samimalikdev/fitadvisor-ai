import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final ApiController _apiController = ApiController();
  final SharedPrefsService _sharedPrefsService = SharedPrefsService();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    isLoading.value = true;
    try {
      final profileData = await _apiController.get('/profile');
      if (profileData != null) {
        nameController.text = profileData['name'] ?? '';
        emailController.text = profileData['email'] ?? '';

        await _sharedPrefsService.saveProfileData(profileData);
      } else {
        final cachedData = await _sharedPrefsService.getProfileData();
        if (cachedData != null) {
          nameController.text = cachedData['name'] ?? '';
          emailController.text = cachedData['email'] ?? '';
        }
      }
    } catch (e) {
      print("Error loading user data for edit profile: \$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      SnackbarHelper.showError("Notice", "Name cannot be empty");
      return;
    }

    isLoading.value = true;
    try {
      final updatePayload = {
        "name": nameController.text.trim(),
      };

      try {
        await _apiController.post('/profile', updatePayload);
        SnackbarHelper.showSuccess("Success", "Profile updated successfully");
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      } catch (e) {
        SnackbarHelper.showError("Error", "Failed to update profile");
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "Server error, try again later");
    } finally {
      isLoading.value = false;
    }
  }
}
