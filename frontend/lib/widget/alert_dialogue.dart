import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';
import 'package:nutrition_ai/models/daily_intake_model.dart';
import 'package:nutrition_ai/widget/text_field.dart';

class AlertDialogue extends StatelessWidget {
  AlertDialogue({
    super.key,
    required this.caloriesController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
  });

  final DailyIntakeController controller = Get.put(DailyIntakeController());

  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dailyIntake = controller.dailyIntakeModel.value;
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Custom Nutrition',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            BuildTextField(
                label: 'Calories',
                hint: 'Enter Calories',
                keyboardType: TextInputType.number,
                controller: caloriesController,
                maxValue: 10000),
            const SizedBox(height: 10),
            BuildTextField(
                label: 'Protein',
                hint: 'Enter Protein',
                keyboardType: TextInputType.number,
                controller: proteinController,
                maxValue: 10000),
            const SizedBox(height: 10),
            BuildTextField(
                label: 'Carbs',
                hint: 'Enter Carbs',
                keyboardType: TextInputType.number,
                controller: carbsController,
                maxValue: 10000),
            const SizedBox(height: 10),
            BuildTextField(
                label: 'Fat',
                hint: 'Enter Fat',
                keyboardType: TextInputType.number,
                controller: fatController,
                maxValue: 10000),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.redAccent,
                    elevation: 10,
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (caloriesController.text.isNotEmpty &&
                        proteinController.text.isNotEmpty &&
                        carbsController.text.isNotEmpty &&
                        fatController.text.isNotEmpty) {
                      print(
                          "calories: ${caloriesController.text}, protein: ${proteinController.text}, carbs: ${carbsController.text}, fat: ${fatController.text}");
                      dailyIntake.clear();
                      dailyIntake.add(
                        DailyIntakeModel(
                            calories: int.parse(caloriesController.text),
                            carbohydrates: int.parse(carbsController.text),
                            fat: int.parse(fatController.text),
                            protein: int.parse(proteinController.text)),
                      );
                      print(jsonEncode(dailyIntake));
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Please fill all fields!',
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    backgroundColor: Colors.yellowAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: Colors.yellowAccent,
                    elevation: 10,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
