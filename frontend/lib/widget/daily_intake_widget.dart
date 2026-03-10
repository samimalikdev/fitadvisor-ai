import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/widget/nutrition_row.dart';

class DailyIntakeContainer extends StatelessWidget {
  const DailyIntakeContainer({
    super.key,
    required this.calorieValue,
    required this.proteinValue,
    required this.carbsValue,
    required this.fatsValue,
    required this.color,
    this.titleText = 'Updated Nutrition Values:',
  });

  final int calorieValue;
  final int proteinValue;
  final int carbsValue;
  final int fatsValue;
  final Color color;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            NutritionRow(
              title: 'Calories',
              value: "$calorieValue kcal",
              color: color,
            ),
            const SizedBox(height: 12),
            NutritionRow(
              title: 'Protein',
              value: "$proteinValue g",
              color: color,
            ),
            const SizedBox(height: 12),
            NutritionRow(
              title: 'Carbohydrates',
              value: "$carbsValue g",
              color: color,
            ),
            const SizedBox(height: 12),
            NutritionRow(
              title: 'Fat',
              value: "$fatsValue g",
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
