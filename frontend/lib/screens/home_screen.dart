import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final DailyIntakeController dailyIntakeController =
      Get.put(DailyIntakeController());
  final MealController mealController = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 52.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              const SizedBox(height: 24),
              _buildMacroSummaryCard(),
              const SizedBox(height: 30),
              _buildSectionTitle('Quick Actions'),
              const SizedBox(height: 16),
              _buildQuickActionsRow(),
              const SizedBox(height: 30),
              _buildSectionTitle('Recent Meals'),
              const SizedBox(height: 16),
              _buildRecentMealsList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back! 👋',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Here's your nutritional summary for today.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroSummaryCard() {
    return Obx(() {
      int targetCalories = 0;
      int targetProtein = 0;
      int targetCarbs = 0;
      int targetFat = 0;

      if (dailyIntakeController.dailyIntakeModel.isNotEmpty) {
        final target = dailyIntakeController.dailyIntakeModel.last;
        targetCalories = target.calories ?? 0;
        targetProtein = target.protein ?? 0;
        targetCarbs = target.carbohydrates ?? 0;
        targetFat = target.fat ?? 0;
      }

      int consumedCalories = 0;
      int consumedProtein = 0;
      int consumedCarbs = 0;
      int consumedFat = 0;

      for (var meal in mealController.calculatedMealModel) {
        consumedCalories += meal.calories ?? 0;
        consumedProtein += meal.protein ?? 0;
        consumedCarbs += meal.carbohydrates ?? 0;
        consumedFat += meal.fat ?? 0;
      }

      final caloriePercentage = targetCalories > 0
          ? (consumedCalories / targetCalories).clamp(0.0, 1.0)
          : 0.0;
      final proteinPercentage = targetProtein > 0
          ? (consumedProtein / targetProtein).clamp(0.0, 1.0)
          : 0.0;
      final carbsPercentage =
          targetCarbs > 0 ? (consumedCarbs / targetCarbs).clamp(0.0, 1.0) : 0.0;
      final fatPercentage =
          targetFat > 0 ? (consumedFat / targetFat).clamp(0.0, 1.0) : 0.0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2979FF).withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2979FF).withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${consumedCalories} / ${targetCalories > 0 ? targetCalories : "-"}',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'kcal consumed',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: caloriePercentage,
                        strokeWidth: 8,
                        backgroundColor:
                            const Color(0xFF2979FF).withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2979FF)),
                      ),
                    ),
                    Text(
                      '${(caloriePercentage * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniProgress('Protein', consumedProtein, targetProtein,
                    proteinPercentage, Colors.blueAccent),
                _buildMiniProgress('Carbs', consumedCarbs, targetCarbs,
                    carbsPercentage, Colors.orangeAccent),
                _buildMiniProgress('Fat', consumedFat, targetFat, fatPercentage,
                    Colors.redAccent),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMiniProgress(
      String label, int consumed, int target, double percentage, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 5,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        Text(
          '${consumed} / ${target > 0 ? target : "-"}g',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'AI Assistant',
                icon: Icons.chat_bubble_outline,
                color: const Color(0xFF6C5CE7),
                onTap: () {
                  Get.toNamed(AppRoutes.askNutritionManager);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Scan Label',
                icon: Icons.document_scanner_outlined,
                color: const Color(0xFF00B894),
                onTap: () {
                  Get.toNamed(AppRoutes.scanLabel);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Water Tracker',
                icon: FontAwesomeIcons.droplet,
                color: Colors.lightBlueAccent,
                onTap: () {
                  Get.toNamed(AppRoutes.waterIntake);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Calculate Intake',
                icon: FontAwesomeIcons.calculator,
                color: Colors.orangeAccent,
                onTap: () {
                  Get.toNamed(AppRoutes.profile);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.8),
              color.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMealsList() {
    return Obx(() {
      final meals = mealController.calculatedMealModel;
      if (meals.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              "No meals saved today.",
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ),
        );
      }

      final recentMeals = meals.reversed.take(3).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentMeals.length,
        itemBuilder: (context, index) {
          final meal = recentMeals[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.foodName ?? "Unknown Meal",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal.calories ?? 0} kcal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FontAwesomeIcons.utensils,
                  color: Colors.white30,
                  size: 20,
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
