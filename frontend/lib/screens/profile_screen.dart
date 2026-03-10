import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/controllers/profile_controller.dart';
import 'package:nutrition_ai/routes/app_routes.dart';
import 'package:nutrition_ai/widget/text_field.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profile & Goals',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitleWithIcon('Personal Information', Icons.person),
              const SizedBox(height: 10),
              BuildTextField(
                label: 'Age',
                hint: 'Enter your age',
                keyboardType: TextInputType.number,
                controller: controller.ageController,
                maxValue: 120,
              ),
              const SizedBox(height: 20),
              BuildTextField(
                label: 'Height (cm)',
                hint: 'Enter your height in cm',
                keyboardType: TextInputType.number,
                controller: controller.heightController,
                maxValue: 250,
              ),
              const SizedBox(height: 20),
              BuildTextField(
                label: 'Weight (kg)',
                hint: 'Enter your weight in kg',
                keyboardType: TextInputType.number,
                controller: controller.weightController,
                maxValue: 200,
              ),
              const SizedBox(height: 30),
              _buildSectionTitleWithIcon('Gender', Icons.male),
              const SizedBox(height: 10),
              _buildRadioButton('Male', controller.selectedGender, onTap: () {
                controller.setGender('Male');
              }),
              _buildRadioButton('Female', controller.selectedGender, onTap: () {
                controller.setGender('Female');
              }),
              const SizedBox(height: 30),
              _buildSectionTitleWithIcon(
                  'Physical Activity Level', Icons.fitness_center),
              const SizedBox(height: 10),
              _buildRadioButton('Sedentary (little or no exercise)',
                  controller.selectedActivityLevel, onTap: () {
                controller
                    .setActivityLevel('Sedentary (little or no exercise)');
              }),
              _buildRadioButton('Moderate Activity (exercise 3-5 days/week)',
                  controller.selectedActivityLevel, onTap: () {
                controller.setActivityLevel(
                    'Moderate Activity (exercise 3-5 days/week)');
              }),
              _buildRadioButton('High Activity (exercise 6-7 days/week)',
                  controller.selectedActivityLevel, onTap: () {
                controller
                    .setActivityLevel('High Activity (exercise 6-7 days/week)');
              }),
              const SizedBox(height: 30),
              _buildSectionTitleWithIcon('Overall Goal', Icons.flag),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGoalCard(
                      title: 'Maintenance',
                      icon: Icons.monitor_weight_outlined,
                      gradientColors: [Colors.blueAccent, Colors.lightBlue],
                      isSelected:
                          controller.selectedGoal.value == 'Maintenance',
                      onTap: () => controller.setGoal('Maintenance'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildGoalCard(
                      title: 'Fat Loss',
                      icon: Icons.trending_down,
                      gradientColors: [Colors.redAccent, Colors.deepOrange],
                      isSelected: controller.selectedGoal.value == 'Fat Loss',
                      onTap: () => controller.setGoal('Fat Loss'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGoalCard(
                      title: 'Weight Gain',
                      icon: Icons.trending_up,
                      gradientColors: [Colors.greenAccent, Colors.teal],
                      isSelected:
                          controller.selectedGoal.value == 'Weight Gain',
                      onTap: () => controller.setGoal('Weight Gain'),
                    ),
                  ),
                ],
              ),
              if (controller.selectedGoal.value != 'Maintenance') ...[
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      if (controller.selectedGoal.value == 'Weight Gain') ...[
                        _quantityOption(
                            'Gain 0.1-0.2kg / week',
                            '0.15',
                            controller.selectedWeeklyTarget,
                            Colors.greenAccent),
                        _quantityOption(
                            'Gain 0.25kg / week',
                            '0.25',
                            controller.selectedWeeklyTarget,
                            Colors.greenAccent),
                        _quantityOption(
                            'Gain 0.5kg / week',
                            '0.5',
                            controller.selectedWeeklyTarget,
                            Colors.greenAccent),
                      ] else if (controller.selectedGoal.value ==
                          'Fat Loss') ...[
                        _quantityOption('Lose 0.1-0.2kg / week', '0.15',
                            controller.selectedWeeklyTarget, Colors.redAccent),
                        _quantityOption('Lose 0.25kg / week', '0.25',
                            controller.selectedWeeklyTarget, Colors.redAccent),
                        _quantityOption('Lose 0.5kg / week', '0.5',
                            controller.selectedWeeklyTarget, Colors.redAccent),
                      ]
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Center(
                child: Container(
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
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.saveProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 40, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Profile & Recalculate Goals',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitleWithIcon(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 26),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioButton(String label, RxString rxValue,
      {VoidCallback? onTap}) {
    final value = rxValue.value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: value == label
              ? const Color(0xFF1A1A1A)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value == label
                ? const Color(0xFF2979FF).withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: value == label
              ? [
                  BoxShadow(
                    color: const Color(0xFF2979FF).withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: value == label ? 1.1 : 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value == label
                      ? const Color(0xFF2979FF)
                      : Colors.transparent,
                  border: value == label
                      ? Border.all(color: Colors.blueAccent, width: 2)
                      : Border.all(
                          color: Colors.grey.withValues(alpha: 0.5), width: 2),
                ),
                child: Icon(
                  Icons.circle,
                  color: value == label ? Colors.white : Colors.transparent,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight:
                      value == label ? FontWeight.w600 : FontWeight.w500,
                  color: value == label ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? gradientColors.first.withValues(alpha: 0.15)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected
                  ? gradientColors.first
                  : Colors.grey.withValues(alpha: 0.1),
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? gradientColors.first.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.2),
              spreadRadius: isSelected ? 1 : 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: gradientColors.first.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: gradientColors.first, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityOption(
      String text, String targetValue, RxString selectedTarget, Color color) {
    bool isSelected = selectedTarget.value == targetValue;
    return GestureDetector(
      onTap: () => controller.setWeeklyTarget(targetValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.8)
                : Colors.grey.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? color : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: color, width: 2)
                      : Border.all(
                          color: Colors.grey.withValues(alpha: 0.5), width: 2),
                ),
                child: Icon(
                  Icons.circle,
                  color: isSelected ? Colors.white : Colors.transparent,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
