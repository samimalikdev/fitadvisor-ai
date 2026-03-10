import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/models/calculated_meal_model.dart';
import 'package:nutrition_ai/models/food_nutrition_details_model.dart';
import 'package:nutrition_ai/models/nutrient_impact_model.dart';
import 'package:nutrition_ai/models/nutritional_info_model.dart';
import 'package:nutrition_ai/models/recommended_food_model.dart';
import 'package:nutrition_ai/models/updated_nutrition_model.dart';
import 'package:nutrition_ai/models/updated_nutrition_model.dart'
    as updated_model;
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';
import 'package:nutrition_ai/screens/ask_nutrition_manager_screen.dart';

class NutritionController extends GetxController {
  var selectedImagePath = ''.obs;
  var nutritionInfo = ''.obs;
  var selectedImageBytes = Rxn<Uint8List>();
  final isScanning = false.obs;
  var showExplanation = false.obs;
  RxList<RxBool> explanations = RxList.generate(9, (index) => false.obs);
  final isLoading = false.obs;
  final badHealthImpact = <Map<String, dynamic>>[].obs;
  TextEditingController quantityController = TextEditingController();
  final RxList<NutritionModel> nutritionModel = RxList<NutritionModel>();
  final RxList<RecommendedFoodModel> recommendedFoodModel =
      RxList<RecommendedFoodModel>();
  final Rx<FoodNutritionDetailsModel> foodNutritionDetailsModel =
      FoodNutritionDetailsModel().obs;
  final RxList<NutrientImpactModel> nutrientImpactModel =
      RxList<NutrientImpactModel>();
  final RxList<UpdatedNutritionModel> updatedNutritionModel =
      RxList<UpdatedNutritionModel>();

  final MealController mealController = Get.put(MealController());
  final ApiController _apiController = ApiController();

  void pickImager() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 1200,
    );

    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;

      final frontImageBytes = await pickedFile.readAsBytes();
      selectedImageBytes.value = frontImageBytes;
    }
  }

  Future<void> scanLabel() async {
    if (selectedImageBytes.value == null) {
      return;
    }
    final frontImageBytes = selectedImageBytes.value!;
    String base64Image = base64Encode(frontImageBytes);

    isScanning.value = true;
    isLoading.value = true;
    updatedNutritionModel.clear();

    try {
      final decodedJson = await _apiController
          .post('/ai/analyze_food_image', {'imageBase64': base64Image});
      if (decodedJson != null) {
        NutritionChatController.currentFoodContext = jsonEncode(decodedJson);
        nutritionModel.add(NutritionModel.fromJson(decodedJson));

        if (nutritionModel.isNotEmpty) {}

        isScanning.value = false;
        isLoading.value = false;

        getRecommendedFoodNames(decodedJson);
        _fetchHealthImpact(decodedJson);
      } else {
        SnackbarHelper.showError("Scan Failed", "Could not analyze image.");
        isScanning.value = false;
        isLoading.value = false;
      }
    } catch (e) {
      SnackbarHelper.showError(
          "Error Occurred", "Server Error Please Try Again Later");
      isScanning.value = false;
      isLoading.value = false;
    }
  }

  Future<void> _fetchHealthImpact(Map<String, dynamic> decodedJson) async {
    try {
      final decodedJson2 = await _apiController
          .post('/ai/health_impact', {'scanned_nutrition': decodedJson});

      if (decodedJson2 != null) {
        foodNutritionDetailsModel.value =
            FoodNutritionDetailsModel.fromJson(decodedJson2);
        await getHealthImpact(decodedJson, decodedJson2);
      }
    } catch (e) {
      print("Error fetching health impact: $e");
    }
  }

  Future<void> getRecommendedFoodNames(
      Map<String, dynamic> nutritionMap) async {
    try {
      if (nutritionMap.isNotEmpty) {
        recommendedFoodModel.clear();

        final decodedJson = await _apiController
            .post('/ai/recommend_foods', {'analyzed_nutrition': nutritionMap});

        if (decodedJson != null) {
          recommendedFoodModel.add(RecommendedFoodModel.fromJson(decodedJson));
          recommendedFoodModel.refresh();
        }
      }
    } catch (e) {
      print("Error getting recommended foods: $e");
    }
  }

  String getSafeNutritionalValue(
      Map<String, dynamic> nutritionMap, String nutrientKey, String suffix) {
    final value =
        nutritionMap['label'][nutrientKey]['value']?.toString() ?? "0";
    return '$value$suffix';
  }

  String getDvPercentage(
      Map<String, dynamic> nutritionMap, String nutrientKey) {
    return '${nutritionMap['label'][nutrientKey]['dv_percentage'] ?? "0"}% DV';
  }

  Future<void> getHealthImpact(Map<String, dynamic> nutritionMap,
      Map<String, dynamic> healthImpactr) async {
    if (nutritionMap.containsKey('label') &&
        nutritionMap['label'] is Map<String, dynamic>) {
      final labelData = nutritionMap['label'] as Map<String, dynamic>;

      badHealthImpact.clear();

      labelData.forEach((key, value) {
        if (value is Map<String, dynamic> &&
            value['health_impact'] == 'Bad health impact') {
          badHealthImpact.add({
            "title": key,
            "health_impact": value['health_impact'],
            "value": value['value'],
            "dv_percentage": value['dv_percentage'].toString(),
            "reason": healthImpactr['reason_of_$key'],
          });
        }
      });

      nutrientImpactModel.value = NutrientImpactModel.fromList(badHealthImpact);
      nutrientImpactModel.refresh();
    }
  }

  String getUnit(String nutrientKey) {
    switch (nutrientKey) {
      case 'carbohydrates':
      case 'fiber':
      case 'fat':
      case 'saturated_fat':
        return 'g';
      case 'sodium':
        return 'mg';
      default:
        return '';
    }
  }

  Future<void> updateQuantity(int newVal) async {
    try {
      if (nutritionModel.isNotEmpty && newVal > 0) {
        updatedNutritionModel.first.amount = newVal;
        updatedNutritionModel.refresh();
      }
    } catch (e) {}
  }

  Future<void> calculateNutrition(int oldQuantity, int newQuantity) async {
    try {
      if (oldQuantity == 0 || newQuantity == 0) {
        return;
      }

      int oldQ = oldQuantity;
      int newQ = newQuantity;

      final ratio = newQ / oldQ;

      if (nutritionModel.isNotEmpty) {
        final label = nutritionModel.first.label;

        if (label != null) {
          int calories = label.calories?.value ?? 0;
          final carbohydrates = label.carbohydrates?.value ?? 0;
          final fat = label.fat?.value ?? 0;
          final protein = label.protein?.value ?? 0;

          final updatedCalories = (calories * ratio).toInt();
          final updatedCarbohydrates = (carbohydrates * ratio).toInt();
          final updatedFat = (fat * ratio).toInt();
          final updatedProtein = (protein * ratio).toInt();

          final updatedNutrition = updated_model.Updated(
            carbohydrates:
                updated_model.Carbohydrates(value: updatedCarbohydrates),
            fat: updated_model.Fat(value: updatedFat),
            calories: updated_model.Calories(value: updatedCalories),
            protein: updated_model.Protein(value: updatedProtein),
          );

          final updatedModelNewEntry = updated_model.UpdatedNutritionModel(
            updated: [updatedNutrition],
          );

          updatedNutritionModel.clear();
          updatedNutritionModel.add(updatedModelNewEntry);

          updatedNutritionModel.refresh();
          updateQuantity(newQuantity);
        }
      }
    } catch (e) {}
  }

  void saveToDailyIntake() {
    if (nutritionModel.isEmpty) return;

    final mealController = Get.put(MealController());

    String mealName = nutritionModel.first.label?.mealName ?? "Scanned Food";
    if (mealName.isEmpty) mealName = "Scanned Food";

    int calories = 0;
    int carbs = 0;
    int fat = 0;
    int protein = 0;

    if (updatedNutritionModel.isNotEmpty) {
      final updated = updatedNutritionModel.first.updated?.first;
      calories = updated?.calories?.value ?? 0;
      carbs = updated?.carbohydrates?.value ?? 0;
      fat = updated?.fat?.value ?? 0;
      protein = updated?.protein?.value ?? 0;
    } else {
      final label = nutritionModel.first.label;
      calories = label?.calories?.value ?? 0;
      carbs = label?.carbohydrates?.value ?? 0;
      fat = label?.fat?.value ?? 0;
      protein = label?.protein?.value ?? 0;
    }

    final newMeal = CalculatedMealModel(
      foodName: mealName,
      calories: calories,
      carbohydrates: carbs,
      fat: fat,
      protein: protein,
    );

    mealController.addMeal(newMeal);
    SnackbarHelper.showSuccess(
        "Saved", "$mealName added to your daily intake.");
  }
}
