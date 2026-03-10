import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nutrition_ai/controllers/nutrition_controller.dart';

class NutritionalCard extends StatelessWidget {
  final String title;
  final String value;
  final String dvPercentage;
  final Color backgroundColor;
  final IconData icon;
  final String? explanation;
  final int index;

  final NutritionController controller = Get.put(NutritionController());

  NutritionalCard({
    required this.title,
    required this.value,
    required this.dvPercentage,
    required this.backgroundColor,
    required this.icon,
    this.explanation = '',
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.explanations[index].value =
            !controller.explanations[index].value;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: backgroundColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: backgroundColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            value,
                            maxFontSize: 24,
                            minFontSize: 18,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            dvPercentage,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFF1C40F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (explanation != null && explanation!.isNotEmpty) ...[
                      Obx(() {
                        if (controller.explanations[index].value) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              explanation!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white60,
                                height: 1.5,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                    ]
                  ],
                ),
              ),
              Obx(() => IconButton(
                    onPressed: () {
                      controller.explanations[index].value =
                          !controller.explanations[index].value;
                    },
                    icon: Icon(
                      controller.explanations[index].value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white54,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
