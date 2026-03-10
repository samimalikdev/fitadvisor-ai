import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/controllers/daily_intake_overview_controller.dart';
import 'package:nutrition_ai/controllers/meal_controller.dart';
import 'package:nutrition_ai/models/calculated_meal_model.dart';
import 'package:nutrition_ai/controllers/nutrition_controller.dart';
import 'package:nutrition_ai/routes/app_routes.dart';
import 'package:nutrition_ai/widget/intake_progress_card.dart';
import 'package:nutrition_ai/widget/text_field.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DailyIntakeOverviewScreen extends StatelessWidget {
  final DailyIntakeController controller = Get.put(DailyIntakeController());
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final NutritionController nutritionController =
      Get.put(NutritionController());
  final DailyIntakeOverviewController dailyIntakeOverviewController =
      Get.put(DailyIntakeOverviewController());
  final CalculatedMealModel calculatedMealModel =
      Get.put(CalculatedMealModel());

  final MealController mealController = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        appBar: AppBar(
          title: Text(
            'Daily Intake Goals',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Obx(() {
                final dailyIntake = controller.dailyIntakeModel;
                final nutritionModel = mealController.calculatedMealModel;
                int totalCalories = nutritionModel.fold(
                    0, (previousVal, e) => previousVal + (e.calories ?? 0));
                int totalProtein = nutritionModel.fold(
                    0, (previousVal, e) => previousVal + (e.protein ?? 0));
                int totalFat = nutritionModel.fold(
                    0, (previousVal, e) => previousVal + (e.fat ?? 0));
                int totalCarbs = nutritionModel.fold(0,
                    (previousVal, e) => previousVal + (e.carbohydrates ?? 0));
                int targetCalories = 0;
                if (dailyIntake.length > 1 && dailyIntake[1].calories != null) {
                  targetCalories = dailyIntake[1].calories!;
                } else if (dailyIntake.isNotEmpty &&
                    dailyIntake.first.calories != null) {
                  targetCalories = dailyIntake.first.calories!;
                }

                double caloriePercentage =
                    targetCalories > 0 ? (totalCalories / targetCalories) : 0.0;

                return Column(
                  children: [
                    if (dailyIntake.isEmpty) ...[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2979FF)
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2979FF)
                                        .withValues(alpha: 0.15),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.bullseye,
                                size: 60,
                                color: Color(0xFF2979FF),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'No Targets Set',
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Calculate your daily intake goals to start tracking your nutrition and meals effectively.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white60,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2979FF),
                                    Color(0xFF0D47A1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent
                                        .withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.profile);
                                },
                                icon: const Icon(Icons.rocket_launch,
                                    color: Colors.white),
                                label: Text(
                                  'Set Your Goals',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2979FF),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Nutritional Details',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  if (dailyIntake.length > 1) ...[
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            spacing: 5,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Calories',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${totalCalories.toString()} / ${dailyIntake[1].calories} kcal',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child:
                                                  CircularProgressIndicator(
                                                value: caloriePercentage
                                                    .clamp(0.0, 1.0),
                                                strokeWidth: 8,
                                                backgroundColor:
                                                    const Color(0xFF2979FF)
                                                        .withValues(
                                                            alpha: 0.2),
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xFF2979FF)),
                                              ),
                                            ),
                                            Text(
                                              '${(caloriePercentage * 100).toStringAsFixed(0)}%',
                                              style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IntakeProgressCard(
                                            title: 'Protein',
                                            min: totalProtein,
                                            max: dailyIntake[1].protein!,
                                            unit: 'g',
                                            color: Colors.blueAccent),
                                        IntakeProgressCard(
                                            title: 'Carbs',
                                            min: totalCarbs,
                                            max:
                                                dailyIntake[1].carbohydrates!,
                                            unit: 'g',
                                            color: Colors.orangeAccent),
                                        IntakeProgressCard(
                                            title: 'Fat',
                                            min: totalFat,
                                            max: dailyIntake[1].fat!,
                                            unit: 'g',
                                            color: Colors.redAccent),
                                      ],
                                    ),
                                  ] else ...[
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            spacing: 5,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Calories',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${totalCalories.toString()} / ${dailyIntake.first.calories} kcal',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child:
                                                  CircularProgressIndicator(
                                                value: caloriePercentage
                                                    .clamp(0.0, 1.0),
                                                strokeWidth: 8,
                                                backgroundColor:
                                                    const Color(0xFF2979FF)
                                                        .withValues(
                                                            alpha: 0.2),
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xFF2979FF)),
                                              ),
                                            ),
                                            Text(
                                              '${(caloriePercentage * 100).toStringAsFixed(0)}%',
                                              style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IntakeProgressCard(
                                            title: 'Protein',
                                            min: totalProtein,
                                            max: dailyIntake.first.protein!,
                                            unit: 'g',
                                            color: Colors.blueAccent),
                                        IntakeProgressCard(
                                            title: 'Carbs',
                                            min: totalCarbs,
                                            max: dailyIntake
                                                .first.carbohydrates!,
                                            unit: 'g',
                                            color: Colors.orangeAccent),
                                        IntakeProgressCard(
                                            title: 'Fat',
                                            min: totalFat,
                                            max: dailyIntake.first.fat!,
                                            unit: 'g',
                                            color: Colors.redAccent),
                                      ],
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2979FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Meals Eaten',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (mealController.calculatedMealModel.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Meals Eaten',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent
                                            .withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: FaIcon(FontAwesomeIcons.utensils,
                                          color: Colors.orangeAccent, size: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...nutritionModel.map((meal) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Slidable(
                                        key: ObjectKey(meal),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          extentRatio: 0.5,
                                          children: [
                                            const SizedBox(width: 8),
                                            CustomSlidableAction(
                                              onPressed: (context) {
                                                mealController.removeMeal(meal);
                                              },
                                              padding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent
                                                      .withValues(alpha: 0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.white,
                                                      size: 28),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1A1A1A),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.white
                                                  .withValues(alpha: 0.05),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                      meal.foodName!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 16,
                                                      maxFontSize: 20,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '${meal.calories.toString()} kcal',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _nutrientBadge(
                                                      '${meal.protein.toString()}g',
                                                      'Protein',
                                                      Colors.blueAccent),
                                                  SizedBox(width: 12),
                                                  _nutrientBadge(
                                                      '${meal.fat.toString()}g',
                                                      'Fat',
                                                      Colors.redAccent),
                                                ],
                                              )
                                            ],
                                          ),
                                        )))),
                                SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.orangeAccent
                                          .withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orangeAccent
                                            .withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Calories',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${totalCalories.toString()} kcal',
                                            style: GoogleFonts.poppins(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(FontAwesomeIcons.fire,
                                          color: Colors.redAccent, size: 30),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                );
              })),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Text(
                      'Add Food By Name',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    BuildTextField(
                        label: 'Enter Grams',
                        hint: 'Enter Grams',
                        keyboardType: TextInputType.number,
                        controller:
                            dailyIntakeOverviewController.gramsController,
                        maxValue: 1000),
                    BuildTextField(
                        label: 'Food Name',
                        hint: 'Enter Food Name',
                        isText: true,
                        keyboardType: TextInputType.text,
                        controller:
                            dailyIntakeOverviewController.nameController,
                        maxValue: 1000),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                    color: Colors.white30, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2979FF), Color(0xFF0D47A1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.blueAccent.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (dailyIntakeOverviewController
                                          .gramsController.text.isNotEmpty ||
                                      dailyIntakeOverviewController
                                          .nameController.text.isNotEmpty) {
                                    dailyIntakeOverviewController
                                        .calculateMeal();
                                    Get.back();
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
          },
          tooltip: 'Add Food',
          backgroundColor: const Color(0xFF2979FF),
          child: const FaIcon(
            FontAwesomeIcons.bowlFood,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _nutrientBadge(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
