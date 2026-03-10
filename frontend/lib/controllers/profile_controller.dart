import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_ai/models/user_profile_model.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class ProfileController extends GetxController {
  final DailyIntakeController dailyIntakeController =
      Get.put(DailyIntakeController());
  final ApiController _apiController = ApiController();
  final SharedPrefsService _sharedPrefsService = SharedPrefsService();

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final RxString selectedGender = 'Male'.obs;
  final RxString selectedActivityLevel =
      'Sedentary (little or no exercise)'.obs;

  final RxString selectedGoal = 'Maintenance'.obs;
  final RxString selectedWeeklyTarget = ''.obs;

  final Rx<UserProfileModel> userProfile = UserProfileModel().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    fetchProfile();
  }

  Future<void> _loadFromCache() async {
    final data = await _sharedPrefsService.getProfileData();
    if (data != null) {
      _applyProfileData(data);
    }
  }

  void _applyProfileData(Map<String, dynamic> data) {
    if (data['age'] != null) {
      userProfile.value = UserProfileModel(
        age: data['age'],
        height: (data['height'] as num?)?.toDouble(),
        weight: (data['weight'] as num?)?.toDouble(),
        gender: data['gender'],
        activityLevel: data['activityLevel'],
        goal: data['goal'],
        weeklyTarget: data['weeklyTarget'],
      );

      ageController.text = data['age']?.toString() ?? '';
      heightController.text = data['height']?.toString() ?? '';
      weightController.text = data['weight']?.toString() ?? '';

      if (data['gender'] != null) selectedGender.value = data['gender'];
      if (data['activityLevel'] != null) {
        selectedActivityLevel.value = data['activityLevel'];
      }
      if (data['goal'] != null) selectedGoal.value = data['goal'];
      if (data['weeklyTarget'] != null) {
        selectedWeeklyTarget.value = data['weeklyTarget'];
      }

      dailyIntakeController.ageController.text = ageController.text;
      dailyIntakeController.heightController.text = heightController.text;
      dailyIntakeController.weightController.text = weightController.text;

      dailyIntakeController.setAge(ageController.text);
      dailyIntakeController.setHeight(heightController.text);
      dailyIntakeController.setWeight(weightController.text);

      dailyIntakeController.setGenderValue(selectedGender.value);
      dailyIntakeController.setActivityLevel(selectedActivityLevel.value);
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final data = await _apiController.get('/profile');
      if (data != null && data['age'] != null) {
        _applyProfileData(data);
        await _sharedPrefsService.saveProfileData(data);
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void setActivityLevel(String level) {
    selectedActivityLevel.value = level;
  }

  void setGoal(String goal) {
    selectedGoal.value = goal;
    selectedWeeklyTarget.value = '';
  }

  void setWeeklyTarget(String target) {
    selectedWeeklyTarget.value = target;
  }

  Future<void> saveProfile() async {
    if (ageController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      SnackbarHelper.showError(
          "Error", "Please fill out all personal information");
      return;
    }

    if (selectedGoal.value != 'Maintenance' &&
        selectedWeeklyTarget.value.isEmpty) {
      SnackbarHelper.showError("Error", "Please select a weekly target amount");
      return;
    }

    isLoading.value = true;

    userProfile.value = UserProfileModel(
      age: int.tryParse(ageController.text),
      height: double.tryParse(heightController.text),
      weight: double.tryParse(weightController.text),
      gender: selectedGender.value,
      activityLevel: selectedActivityLevel.value,
      goal: selectedGoal.value,
      weeklyTarget: selectedWeeklyTarget.value,
    );

    final profileMap = {
      "age": userProfile.value.age,
      "height": userProfile.value.height,
      "weight": userProfile.value.weight,
      "gender": userProfile.value.gender,
      "activityLevel": userProfile.value.activityLevel,
      "goal": userProfile.value.goal,
      "weeklyTarget": userProfile.value.weeklyTarget,
    };

    try {
      await _apiController.post('/profile', profileMap);
    } catch (e) {
      print("Error saving profile: $e");
    }

    await _sharedPrefsService.saveProfileData(profileMap);

    dailyIntakeController.ageController.text = ageController.text;
    dailyIntakeController.heightController.text = heightController.text;
    dailyIntakeController.weightController.text = weightController.text;

    dailyIntakeController.setAge(ageController.text);
    dailyIntakeController.setHeight(heightController.text);
    dailyIntakeController.setWeight(weightController.text);

    dailyIntakeController.setGenderValue(selectedGender.value);
    dailyIntakeController.setActivityLevel(selectedActivityLevel.value);

    await dailyIntakeController.calculate();

    if (dailyIntakeController.dailyIntakeModel.isNotEmpty) {
      if (selectedGoal.value == 'Weight Gain') {
        if (selectedWeeklyTarget.value == '0.15') {
          await dailyIntakeController.calculateWeightChange(250, 60,
              isWeightGain: true);
        } else if (selectedWeeklyTarget.value == '0.25') {
          await dailyIntakeController.calculateWeightChange(350, 90,
              isWeightGain: true);
        } else if (selectedWeeklyTarget.value == '0.5') {
          await dailyIntakeController.calculateWeightChange(700, 120,
              isWeightGain: true);
        }
      } else if (selectedGoal.value == 'Fat Loss') {
        if (selectedWeeklyTarget.value == '0.15') {
          await dailyIntakeController.calculateWeightChange(300, 50,
              isWeightGain: false);
        } else if (selectedWeeklyTarget.value == '0.25') {
          await dailyIntakeController.calculateWeightChange(400, 80,
              isWeightGain: false);
        } else if (selectedWeeklyTarget.value == '0.5') {
          await dailyIntakeController.calculateWeightChange(600, 120,
              isWeightGain: false);
        }
      }
    }

    isLoading.value = false;
    SnackbarHelper.showSuccess(
        "Success", "Profile saved and targets recalculated");

    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}
