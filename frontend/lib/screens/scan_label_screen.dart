import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nutrition_ai/widget/nutritional_card.dart';
import 'package:nutrition_ai/controllers/nutrition_controller.dart';
import 'package:nutrition_ai/widget/daily_intake_widget.dart';
import 'package:nutrition_ai/routes/app_routes.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class ScanLabelScreen extends StatelessWidget {
  final NutritionController nutritionController =
      Get.put(NutritionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Scan Label',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF1E1E1E), const Color(0xFF121212)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade800, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]),
              child: Obx(() {
                return nutritionController.selectedImagePath.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.grey[600],
                              size: 80,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to add product image',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      )
                    : Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(nutritionController.selectedImagePath.value),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                          ),
                        ),
                        if (nutritionController.isScanning.value)
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: Lottie.asset(
                              'assets/animations/scan.json',
                              fit: BoxFit.cover,
                            ),
                          )
                      ]);
              }),
            ),
            const SizedBox(height: 30),
            Card(
              color: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.1), width: 1),
              ),
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.4),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.blueAccent, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI Nutritional Setup',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan a product front or label from your gallery to get an instant nutritional breakdown.',
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Start scanning the product',
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2979FF), Color(0xFF0D47A1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          nutritionController.scanLabel();
                        },
                        icon: const Icon(Icons.qr_code_scanner,
                            color: Colors.white, size: 22),
                        label: Text(
                          'Scan Now',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
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
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Tooltip(
                    message: 'Choose an image from your gallery',
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          nutritionController.pickImager();
                        },
                        icon: const Icon(Icons.photo_library_outlined,
                            color: Colors.white, size: 22),
                        label: Text(
                          'Gallery',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Tooltip(
                    message: 'Ask the Nutrition Assistant',
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF00B4DB).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(AppRoutes.askNutritionManager);
                          SnackbarHelper.showInfo('Chat Assistant',
                              'You can now ask deeper questions about this product!');
                        },
                        icon: const Icon(Icons.mark_chat_unread_rounded,
                            color: Colors.white, size: 20),
                        label: Text(
                          'Ask AI Assistant',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
              final isLoading = nutritionController.isLoading.value;
              final nutrientImpactModel =
                  nutritionController.nutrientImpactModel;
              final recommendedFoodModel =
                  nutritionController.recommendedFoodModel;
              final foodNutritionDetailsModel =
                  nutritionController.foodNutritionDetailsModel.value!;

              final nutritionModel = nutritionController.nutritionModel;
              final updatedNutritionModel =
                  nutritionController.updatedNutritionModel;

              String? servingSize = updatedNutritionModel.isNotEmpty
                  ? (updatedNutritionModel.first.amount?.toString() ?? "0")
                  : (nutritionModel.isNotEmpty
                      ? (nutritionModel.first.label?.estimatedQuantity?.amount
                              ?.toString() ??
                          "0")
                      : "0");

              if (isLoading) {
                return Container(
                  width: double.infinity,
                  height: 100,
                  child: Lottie.asset('assets/animations/loading.json',
                      width: double.infinity),
                );
              }

              if (nutritionModel.isEmpty) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  child: Text(
                    'Scan a product to get started',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                );
              }
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          nutritionModel.first.label?.mealName ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 30,
                                    color: Color(0xFF2ECC71),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Optimal Nutrients',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              NutritionalCard(
                                title: 'Energy',
                                index: 6,
                                value:
                                    "${nutritionModel.first.label?.calories?.value ?? 0}kcal",
                                explanation: foodNutritionDetailsModel
                                        .reasonOfCalories ??
                                    "",
                                dvPercentage:
                                    "${nutritionModel.first.label?.calories?.dvPercentage ?? 0}%DV",
                                backgroundColor: Color(0xFF192A56),
                                icon: Icons.info_outline,
                              ),
                              NutritionalCard(
                                title: 'Protein',
                                index: 7,
                                value:
                                    "${nutritionModel.first.label?.protein?.value ?? 0}g",
                                explanation:
                                    foodNutritionDetailsModel.reasonOfProtein ??
                                        "",
                                dvPercentage:
                                    "${nutritionModel.first.label?.protein?.dvPercentage ?? 0}%DV",
                                backgroundColor: Color(0xFF6C5CE7),
                                icon: Icons.check_circle_outline,
                              ),
                              NutritionalCard(
                                title: 'Carbohydrate',
                                index: 8,
                                value:
                                    "${nutritionModel.first.label?.carbohydrates?.value ?? 0}g",
                                explanation:
                                    foodNutritionDetailsModel.reasonOfCarbs ??
                                        "",
                                dvPercentage:
                                    "${nutritionModel.first.label?.carbohydrates?.dvPercentage ?? 0}%DV",
                                backgroundColor: Color.fromARGB(255, 32, 7, 56),
                                icon: Icons.info_outline,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 30,
                                    color: Color(0xFFE74C3C),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Watch Out',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (nutrientImpactModel.isNotEmpty) ...[
                                ListView.builder(
                                    itemCount: nutrientImpactModel.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final title =
                                          nutrientImpactModel[index].title;
                                      final clean = title?.replaceAll('_', ' ');
                                      final formatted = title != null
                                          ? clean!
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              clean.substring(1).toLowerCase()
                                          : '';
                                      final unit =
                                          nutritionController.getUnit(title!);

                                      return NutritionalCard(
                                        index: index,
                                        title: formatted ?? "",
                                        value: nutrientImpactModel[index]
                                                    .value !=
                                                null
                                            ? "${nutrientImpactModel[index].value}$unit"
                                            : "0",
                                        dvPercentage: nutrientImpactModel[index]
                                                    .dvPercentage !=
                                                null
                                            ? "${nutrientImpactModel[index].dvPercentage}% DV"
                                            : "0% DV",
                                        backgroundColor: Color(0xFFE74C3C),
                                        icon: Icons.warning_amber_rounded,
                                        explanation:
                                            nutrientImpactModel[index].reason ??
                                                "",
                                      );
                                    }),
                              ] else ...[
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.redAccent,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    'Serving Size: $servingSize${nutritionModel.first.label?.estimatedQuantity?.unit ?? ''}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showDialogue(nutritionModel.first.label
                                              ?.estimatedQuantity?.amount
                                              ?.toString() ??
                                          "0");
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (recommendedFoodModel.isNotEmpty) ...[
                                SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          spreadRadius: 1,
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Colors.grey
                                              .withValues(alpha: 0.1),
                                          width: 1),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recommended Foods to Complement Your Meal:',
                                          maxLines: 2,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              recommendedFoodModel.length,
                                          itemBuilder: (context, index) {
                                            var foodModel =
                                                recommendedFoodModel[index];

                                            if (foodModel.foodItems != null &&
                                                foodModel
                                                    .foodItems!.isNotEmpty) {
                                              return Column(
                                                  children: foodModel.foodItems!
                                                      .map((e) {
                                                return _buildRecommendationText(
                                                    foodName: e.foodName!,
                                                    description:
                                                        e.description!);
                                              }).toList());
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Colors.grey.withValues(alpha: 0.15),
                                      width: 1),
                                ),
                                child: Text(
                                  'How much did you consume?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121212),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      _quantityOption('1/4', onTap: () {
                                        nutritionController.calculateNutrition(
                                            nutritionModel
                                                    .first
                                                    .label
                                                    ?.estimatedQuantity
                                                    ?.amount ??
                                                100,
                                            25);
                                        print('1/4 tapped');
                                      }),
                                      _quantityOption('1/2', onTap: () {
                                        nutritionController.calculateNutrition(
                                            nutritionModel
                                                    .first
                                                    .label
                                                    ?.estimatedQuantity
                                                    ?.amount ??
                                                100,
                                            50);
                                        print('1/2 tapped');
                                      }),
                                      _quantityOption('3/4', onTap: () {
                                        nutritionController.calculateNutrition(
                                            nutritionModel
                                                    .first
                                                    .label
                                                    ?.estimatedQuantity
                                                    ?.amount ??
                                                100,
                                            75);
                                        print('3/4 tapped');
                                      }),
                                      _quantityOption('1', onTap: () {
                                        nutritionController.calculateNutrition(
                                            nutritionModel
                                                    .first
                                                    .label
                                                    ?.estimatedQuantity
                                                    ?.amount ??
                                                100,
                                            100);
                                        print('1 tapped');
                                      }),
                                      _quantityOption('Custom', onTap: () {
                                        _showDialogue(nutritionController
                                            .quantityController.text);

                                        print('Custom tapped');
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF2979FF),
                                        Color(0xFF0D47A1)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueAccent
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      nutritionController.saveToDailyIntake();
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    label: Text(
                                      "Save to Daily Intake",
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
                                          horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (updatedNutritionModel.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2979FF),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Updated Nutrition',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      DailyIntakeContainer(
                                        calorieValue: updatedNutritionModel
                                                .first
                                                .updated
                                                ?.first
                                                .calories
                                                ?.value ??
                                            0,
                                        proteinValue: updatedNutritionModel
                                                .first
                                                .updated
                                                ?.first
                                                .protein
                                                ?.value ??
                                            0,
                                        carbsValue: updatedNutritionModel
                                                .first
                                                .updated
                                                ?.first
                                                .carbohydrates
                                                ?.value ??
                                            0,
                                        fatsValue: updatedNutritionModel.first
                                                .updated?.first.fat?.value ??
                                            0,
                                        color: Colors.greenAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _quantityOption(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationText(
      {required String foodName, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.greenAccent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$foodName: ',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogue(String? val) {
    Get.dialog(
      Dialog(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Edit Quantity",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nutritionController.quantityController,
                decoration: InputDecoration(
                  hintText: "Enter Quantity",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {
                        Get.back(),
                        nutritionController.quantityController.clear()
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.4),
                              width: 1.5),
                        ),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        nutritionController.calculateNutrition(
                            nutritionController.nutritionModel.first.label!
                                .estimatedQuantity!.amount!,
                            int.parse(
                                nutritionController.quantityController.text));
                        nutritionController.quantityController.clear();
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00B4DB)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: Text(
                          "Save",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
