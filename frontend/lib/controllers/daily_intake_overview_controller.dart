import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/models/calculated_meal_model.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/screens/ask_nutrition_manager_screen.dart';

class DailyIntakeOverviewController extends GetxController {
  final RxBool isLoading = false.obs;
  final ApiController _apiController = ApiController();

  final TextEditingController gramsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final MealController mealController = Get.put(MealController());

  Future<void> calculateMeal() async {
    isLoading.value = true;
    try {
      final responseData = await _apiController.post('/ai/analyze_meal_name', {
        'mealName': nameController.text,
        'grams': gramsController.text,
      });

      if (responseData != null) {
        NutritionChatController.currentFoodContext = jsonEncode(responseData);
        final cals = responseData['nutrition']['calories'];
        final meal = CalculatedMealModel(
          foodName: responseData['foodName'],
          calories: cals,
          carbohydrates: responseData['nutrition']['carbohydrates'],
          fat: responseData['nutrition']['fat'],
          protein: responseData['nutrition']['protein'],
        );

        await mealController.addMeal(meal);
      }
    } catch (e) {
      print("Error calculateMeal: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
