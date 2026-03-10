import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nutrition_ai/models/daily_intake_model.dart';
import 'package:nutrition_ai/controllers/nutrition_controller.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class DailyIntakeController extends GetxController {
  final SharedPrefsService _sharedPrefsService = SharedPrefsService();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  RxString age = ''.obs;
  RxString height = ''.obs;
  RxString weight = ''.obs;
  NutritionController nutritionController = Get.put(NutritionController());
  final RxList<DailyIntakeModel> dailyIntakeModel = RxList<DailyIntakeModel>();
  RxBool optional = false.obs;
  RxBool weightGain = false.obs;
  RxBool weightLoss = false.obs;
  final ApiController _apiController = ApiController();

  RxString selectedWeightGain = ''.obs;
  RxString selectedWeightLoss = ''.obs;

  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController fatController = TextEditingController();

  var selectedActivityLevel = ''.obs;
  var genderValue = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    final data = await _sharedPrefsService.getDailyIntakeData();
    if (data != null && data.isNotEmpty) {
      dailyIntakeModel.clear();
      for (var item in data) {
        if (item is Map) {
          dailyIntakeModel.add(DailyIntakeModel(
            calories: item['calories'],
            carbohydrates: item['carbohydrates'] ?? item['carbs'],
            fat: item['fat'],
            protein: item['protein'],
          ));
        }
      }
    }
  }

  Future<void> _saveToCache() async {
    final list = dailyIntakeModel
        .map((e) => {
              'calories': e.calories,
              'carbohydrates': e.carbohydrates,
              'fat': e.fat,
              'protein': e.protein,
            })
        .toList();
    await _sharedPrefsService.saveDailyIntakeData(list);
  }

  void setAge(String value) {
    age.value = value;
    print(age.value);
  }

  void setHeight(String value) {
    height.value = value;
    print(height.value);
  }

  void setWeight(String value) {
    weight.value = value;
    print(weight.value);
  }

  void setActivityLevel(String level) {
    selectedActivityLevel.value = level;
  }

  void setGenderValue(String level) {
    genderValue.value = level;
    print("genderValue: $level");
  }

  void setWeightGain(String amount) {
    selectedWeightGain.value = amount;
    print("selectedWeightGain: $selectedWeightGain");
  }

  void setWeightLoss(String amount) {
    selectedWeightLoss.value = amount;
    print("selectedWeightLoss: $selectedWeightLoss");
  }

  Future<void> calculate() async {
    if (ageController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty) {
      SnackbarHelper.showError("Error", "Please enter all the fields");
      return;
    }

    if (genderValue.value.isEmpty || selectedActivityLevel.value.isEmpty) {
      SnackbarHelper.showError(
          "Error", "Please select gender and activity level");
      return;
    }

    int? ageV = int.tryParse(ageController.text);
    double? heightV = double.tryParse(heightController.text);
    double? weightV = double.tryParse(weightController.text);

    if (ageV == null || heightV == null || weightV == null) {
      SnackbarHelper.showError(
          "Error", "Please enter valid age, height and weight");
      return;
    }

    isLoading.value = true;
    dailyIntakeModel.clear();
    selectedWeightGain.value = '';
    selectedWeightLoss.value = '';

    try {
      final payload = {
        "age": age.value,
        "gender": genderValue.value,
        "height": height.value,
        "weight": weight.value,
        "activityLevel": selectedActivityLevel.value,
      };
      print("payload: $payload");
      final responseText =
          await _apiController.post('/ai/calculate_intake', payload);

      if (responseText != null) {
        try {
          dailyIntakeModel.add(DailyIntakeModel(
            calories: responseText['dailyIntake']['calories'],
            carbohydrates: responseText['dailyIntake']['carbohydrates'],
            fat: responseText['dailyIntake']['fat'],
            protein: responseText['dailyIntake']['protein'],
          ));
          await _saveToCache();
        } catch (parseError) {
          print("JSON Parsing Error: $parseError");
          SnackbarHelper.showError(
              "Parsing Error", "Could not read the nutrition data properly.");
        } finally {
          isLoading.value = false;
        }
      } else {
        throw const FormatException("API Response was null.");
      }
    } catch (e) {
      SnackbarHelper.showError(
          "Error Occurred", "Server Error Please Try Again Later");
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> calculateWeightChange(int cals, int carbs,
      {bool isWeightGain = true}) async {
    try {
      if (dailyIntakeModel.isNotEmpty) {
        var calories = dailyIntakeModel.first.calories ?? 0;
        var carbohydrates = dailyIntakeModel.first.carbohydrates ?? 0;
        var fat = dailyIntakeModel.first.fat ?? 0;
        var protein = dailyIntakeModel.first.protein ?? 0;

        if (isWeightGain) {
          calories += cals;
          carbohydrates += carbs;
        } else {
          calories -= cals;
          carbohydrates -= carbs;
        }

        calories = calories < 0 ? 0 : calories;
        carbohydrates = carbohydrates < 0 ? 0 : carbohydrates;

        dailyIntakeModel.add(DailyIntakeModel(
          calories: calories,
          carbohydrates: carbohydrates,
          fat: fat,
          protein: protein,
        ));

        print(json.encode(dailyIntakeModel.last.toJson()));
        await _saveToCache();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void toggleVisibility() {
    weightLoss.value = false;
    weightGain.value = false;
    optional.value = !optional.value;
  }

  void toggleWeightGain() {
    weightLoss.value = false;
    weightGain.value = !weightGain.value;
    print("weightGain: $weightGain");
  }

  void toggleWeightLoss() {
    weightGain.value = false;
    weightLoss.value = !weightLoss.value;

    print("weightGain: $weightLoss");
  }

  void toggleWeightGain1(String amount) {
    selectedWeightLoss.value = '';
    selectedWeightGain.value = amount;
    if (dailyIntakeModel.length > 1) {
      dailyIntakeModel.removeAt(1);
      print("removed");
    }
    print("selectedWeightGain: $selectedWeightGain");
  }

  void toggleWeightLoss1(String amount) {
    selectedWeightGain.value = '';
    selectedWeightLoss.value = amount;
    if (dailyIntakeModel.length > 1) {
      dailyIntakeModel.removeAt(1);
      print("removed");
    }
    print("selectedWeightLoss: $selectedWeightLoss");
  }
}
