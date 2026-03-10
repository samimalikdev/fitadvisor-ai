import 'package:get/get.dart';
import 'package:nutrition_ai/models/calculated_meal_model.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/controllers/history_controller.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';
import 'package:intl/intl.dart';

class MealController extends GetxController {
  final RxList<CalculatedMealModel> calculatedMealModel =
      RxList<CalculatedMealModel>();
  final ApiController _apiController = ApiController();

  @override
  void onInit() {
    super.onInit();
    _fetchTodayMeals();
  }

  Future<void> _fetchTodayMeals() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final logData = await _apiController.get('/history/$today');
      if (logData != null && logData['meals'] != null) {
        calculatedMealModel.clear();
        for (var meal in logData['meals']) {
          calculatedMealModel.add(CalculatedMealModel(
            foodName: meal['name'],
            calories: meal['calories'],
            protein: meal['protein'],
            carbohydrates: meal['carbs'],
            fat: meal['fat'],
            time: meal['time'],
          ));
        }
        update();
      }
    } catch (e) {
      if (!e.toString().contains('404')) {
        print("Error fetching today's meals: $e");
      }
    }
  }

  Map<String, dynamic>? _getCurrentTargetMacros() {
    try {
      if (Get.isRegistered<DailyIntakeController>()) {
        final intakeController = Get.find<DailyIntakeController>();
        if (intakeController.dailyIntakeModel.isNotEmpty) {
          final target = intakeController.dailyIntakeModel.last;
          return {
            "calories": target.calories ?? 0,
            "protein": target.protein ?? 0,
            "carbs": target.carbohydrates ?? 0,
            "fat": target.fat ?? 0,
          };
        }
      }
    } catch (e) {
      print("Error getting target macros: $e");
    }
    return null;
  }

  Future<void> addMeal(CalculatedMealModel meal) async {
    calculatedMealModel.add(meal);

    final timeStr = meal.time ?? DateTime.now().toIso8601String();
    meal.time = timeStr;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final mealData = {
      "name": meal.foodName,
      "calories": meal.calories,
      "protein": meal.protein,
      "carbs": meal.carbohydrates,
      "fat": meal.fat,
      "time": timeStr,
    };

    final targetMacros = _getCurrentTargetMacros();

    final body = {
      'date': today,
      'meal': mealData,
    };
    if (targetMacros != null) {
      body['targetMacros'] = targetMacros;
    }

    try {
      await _apiController.post('/history/add_meal', body);
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().fetchHistory();
      }
    } catch (e) {
      print("Error adding meal: $e");
      SnackbarHelper.showError("Error", "Failed to add meal to history.");
    }

    update();
  }

  Future<void> removeMeal(CalculatedMealModel meal) async {
    calculatedMealModel.remove(meal);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (meal.time != null) {
      final mealData = {
        "calories": meal.calories,
        "protein": meal.protein,
        "carbs": meal.carbohydrates,
        "fat": meal.fat,
        "time": meal.time,
      };

      final targetMacros = _getCurrentTargetMacros();

      final body = {
        'date': today,
        'meal': mealData,
      };
      if (targetMacros != null) {
        body['targetMacros'] = targetMacros;
      }

      try {
        await _apiController.post('/history/remove_meal', body);
        if (Get.isRegistered<HistoryController>()) {
          Get.find<HistoryController>().fetchHistory();
        }
      } catch (e) {
        print("Error removing meal: $e");
        SnackbarHelper.showError("Error", "Failed to remove meal.");
      }
    }

    update();
  }
}
