import 'package:get/get.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/models/recipe_model.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class RecipeController extends GetxController {
  final ApiController _apiController = ApiController();
  final DailyIntakeController _dailyIntakeController =
      Get.put(DailyIntakeController());
  final MealController _mealController = Get.put(MealController());

  final RxBool isLoading = false.obs;
  final RxList<RecipeModel> suggestedRecipes = <RecipeModel>[].obs;

  final RxString selectedCuisine = 'Any'.obs;
  final List<String> cuisineOptions = [
    'Any',
    'Desi',
    'Chinese',
    'Thai',
    'Italian',
    'Mexican',
    'Mediterranean'
  ];

  final RxString selectedDietary = 'Any'.obs;
  final List<String> dietaryOptions = ['Any', 'Vegetarian', 'Non-Veg'];

  final RxString selectedHalal = 'Any'.obs;
  final List<String> halalOptions = ['Any', 'Halal'];

  Future<void> generateRecipes() async {
    try {
      if (_dailyIntakeController.dailyIntakeModel.isEmpty) {
        SnackbarHelper.showError("Setup Required",
            "Please calculate your Daily Intake in the Setup first.");
        return;
      }

      isLoading.value = true;
      suggestedRecipes.clear();

      final target = _dailyIntakeController.dailyIntakeModel.first;
      int targetCalories = target.calories ?? 0;
      int targetProtein = target.protein ?? 0;
      int targetCarbs = target.carbohydrates ?? 0;
      int targetFat = target.fat ?? 0;

      int consumedCalories = 0;
      int consumedProtein = 0;
      int consumedCarbs = 0;
      int consumedFat = 0;

      for (var meal in _mealController.calculatedMealModel) {
        consumedCalories += meal.calories ?? 0;
        consumedProtein += meal.protein ?? 0;
        consumedCarbs += meal.carbohydrates ?? 0;
        consumedFat += meal.fat ?? 0;
      }

      int remainingCalories = targetCalories - consumedCalories;
      int remainingProtein = targetProtein - consumedProtein;
      int remainingCarbs = targetCarbs - consumedCarbs;
      int remainingFat = targetFat - consumedFat;

      if (remainingCalories <= 0) {
        SnackbarHelper.showInfo("Goal Reached",
            "You have hit your macro goals for today! Maybe save recipes for tomorrow.");
      }

      final payload = {
        "remainingCalories": remainingCalories > 0 ? remainingCalories : 100,
        "remainingProtein": remainingProtein > 0 ? remainingProtein : 10,
        "remainingCarbs": remainingCarbs > 0 ? remainingCarbs : 10,
        "remainingFat": remainingFat > 0 ? remainingFat : 5,
        "cuisinePreference": selectedCuisine.value,
        "dietaryPreference": selectedDietary.value,
        "halalPreference": selectedHalal.value,
      };

      final responseData =
          await _apiController.post('/ai/generate_recipes', payload);

      if (responseData != null) {
        if (responseData['recipes'] != null &&
            responseData['recipes'] is List) {
          final recipesList = (responseData['recipes'] as List)
              .map((e) => RecipeModel.fromJson(e))
              .toList();
          suggestedRecipes.addAll(recipesList);
        }
      }
    } catch (e) {
      print("Recipe generation error: $e");
      SnackbarHelper.showError(
          "Generation Failed", "Could not generate recipes at this time.");
    } finally {
      isLoading.value = false;
    }
  }
}
