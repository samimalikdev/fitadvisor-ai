import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/controllers/recipe_controller.dart';
import 'package:nutrition_ai/models/calculated_meal_model.dart';
import 'package:nutrition_ai/models/recipe_model.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';
import 'package:nutrition_ai/widget/daily_intake_widget.dart';

class RecipeGeneratorScreen extends StatelessWidget {
  final RecipeController recipeController = Get.put(RecipeController());
  final DailyIntakeController _dailyIntakeController =
      Get.put(DailyIntakeController());
  final MealController _mealController = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'AI Recipe Generator',
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
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 52.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroHeader(),
              const SizedBox(height: 24),
              _buildMacroTargetCard(),
              const SizedBox(height: 20),
              _buildPreferenceSelectors(),
              const SizedBox(height: 20),
              _buildGenerateButton(),
              const SizedBox(height: 40),
              Obx(() {
                if (recipeController.isLoading.value) {
                  return Center(
                    child: Column(
                      children: [
                        Lottie.asset('assets/animations/loading.json',
                            width: 150),
                        const SizedBox(height: 16),
                        Text(
                          "Creating your perfect recipes...",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (recipeController.suggestedRecipes.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Custom Recipes',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeController.suggestedRecipes.length,
                      itemBuilder: (context, index) {
                        return _buildRecipeCard(
                            recipeController.suggestedRecipes[index]);
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant_menu,
                color: Colors.deepPurpleAccent, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'What should I eat?',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'The AI will invent custom recipes that perfectly fill your remaining daily macros.',
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTargetCard() {
    return Obx(() {
      int remainingCalories = 0;
      int remainingProtein = 0;
      int remainingCarbs = 0;
      int remainingFat = 0;

      if (_dailyIntakeController.dailyIntakeModel.isNotEmpty) {
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

        remainingCalories = targetCalories - consumedCalories;
        remainingProtein = targetProtein - consumedProtein;
        remainingCarbs = targetCarbs - consumedCarbs;
        remainingFat = targetFat - consumedFat;

        if (remainingCalories < 0) remainingCalories = 0;
        if (remainingProtein < 0) remainingProtein = 0;
        if (remainingCarbs < 0) remainingCarbs = 0;
        if (remainingFat < 0) remainingFat = 0;
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Targeting Remaining Macros:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _macroCircle('Calories', remainingCalories.toString(),
                    Colors.orangeAccent),
                _macroCircle(
                    'Protein', '${remainingProtein}g', Colors.blueAccent),
                _macroCircle(
                    'Carbs', "${remainingCarbs}g", Colors.purpleAccent),
                _macroCircle('Fat', "${remainingFat}g", Colors.redAccent),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _macroCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            color: color.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return Center(
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF4834D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            recipeController.generateRecipes();
          },
          icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
          label: Text(
            'Generate Magic Recipes',
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChoiceChipRow(
          title: 'Cuisine Preference',
          options: recipeController.cuisineOptions,
          selectedValue: recipeController.selectedCuisine,
        ),
        const SizedBox(height: 16),
        _buildChoiceChipRow(
          title: 'Dietary Preference',
          options: recipeController.dietaryOptions,
          selectedValue: recipeController.selectedDietary,
        ),
        const SizedBox(height: 16),
        _buildChoiceChipRow(
          title: 'Halal Preference',
          options: recipeController.halalOptions,
          selectedValue: recipeController.selectedHalal,
        ),
      ],
    );
  }

  Widget _buildChoiceChipRow({
    required String title,
    required List<String> options,
    required RxString selectedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              return Obx(() {
                final isSelected = selectedValue.value == option;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        selectedValue.value = option;
                      }
                    },
                    selectedColor:
                        const Color(0xFF6C5CE7).withValues(alpha: 0.8),
                    backgroundColor: const Color(0xFF1E1E1E),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    elevation: isSelected ? 4 : 0,
                    shadowColor: const Color(0xFF6C5CE7).withValues(alpha: 0.4),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: Colors.deepPurpleAccent,
          collapsedIconColor: Colors.white70,
          title: Text(
            recipe.recipeName ?? "Unknown Recipe",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              recipe.description ?? "",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white60,
                height: 1.4,
              ),
            ),
          ),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const Divider(color: Colors.white10, thickness: 1),
            const SizedBox(height: 12),
            _buildSectionHeader("Nutritional Profile"),
            const SizedBox(height: 8),
            DailyIntakeContainer(
              calorieValue: recipe.nutrition?.calories ?? 0,
              proteinValue: recipe.nutrition?.protein ?? 0,
              carbsValue: recipe.nutrition?.carbohydrates ?? 0,
              fatsValue: recipe.nutrition?.fat ?? 0,
              color: Colors.deepPurpleAccent,
              titleText: 'Nutrition per Serving',
            ),
            const SizedBox(height: 20),
            _buildSectionHeader("Ingredients"),
            const SizedBox(height: 8),
            if (recipe.ingredients != null)
              ...recipe.ingredients!.map((ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent, fontSize: 16)),
                        Expanded(
                            child: Text(ingredient,
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 14))),
                      ],
                    ),
                  )),
            const SizedBox(height: 20),
            _buildSectionHeader("Instructions"),
            const SizedBox(height: 8),
            if (recipe.instructions != null)
              ...recipe.instructions!.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${entry.key + 1}. ",
                            style: GoogleFonts.poppins(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Expanded(
                            child: Text(entry.value,
                                style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.4))),
                      ],
                    ),
                  )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final meal = CalculatedMealModel(
                    foodName: recipe.recipeName,
                    calories: recipe.nutrition?.calories ?? 0,
                    carbohydrates: recipe.nutrition?.carbohydrates ?? 0,
                    fat: recipe.nutrition?.fat ?? 0,
                    protein: recipe.nutrition?.protein ?? 0,
                  );
                  _mealController.addMeal(meal);
                  SnackbarHelper.showSuccess(
                      "Success", "${recipe.recipeName} added to history!");
                },
                icon: const Icon(Icons.add_task),
                label: Text(
                  "Log as Meal",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    );
  }
}
