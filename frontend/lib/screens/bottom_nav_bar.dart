import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:nutrition_ai/screens/daily_intake_overwiew_screen.dart';
import 'package:nutrition_ai/screens/profile_screen.dart';
import 'package:nutrition_ai/screens/history_screen.dart';
import 'package:nutrition_ai/screens/recipe_generator_screen.dart';
import 'package:nutrition_ai/screens/home_screen.dart';
import 'package:nutrition_ai/screens/settings_screen.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
    HapticFeedback.lightImpact();
  }
}

class BottomNavScreen extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  BottomNavScreen({super.key});

  final List<Widget> _screens = [
    HomeScreen(),
    RecipeGeneratorScreen(),
    DailyIntakeOverviewScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: _screens,
          ),
        ),
        bottomNavigationBar: Obx(
          () => ModernBottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTabIndex,
          ),
        ),
      ),
    );
  }
}

class ModernBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ModernBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  activeIcon: Icons.home_filled,
                  index: 0,
                  label: 'Home',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                ),
                _buildNavItem(
                  icon: Icons.restaurant_menu,
                  activeIcon: Icons.restaurant,
                  index: 1,
                  label: 'Recipes',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                  ),
                ),
                _buildNavItem(
                  icon: Icons.add_circle_outline_rounded,
                  activeIcon: Icons.add_circle_rounded,
                  index: 2,
                  label: 'Intake',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2F5259), Color(0xFF3D6A73)],
                  ),
                ),
                _buildNavItem(
                  icon: Icons.history_rounded,
                  activeIcon: Icons.history,
                  index: 3,
                  label: 'History',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5AF19), Color(0xFFF12711)],
                  ),
                ),
                _buildNavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  index: 4,
                  label: 'Profile',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00F260), Color(0xFF0575E6)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
    required Gradient gradient,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return (isSelected
                        ? gradient
                        : const LinearGradient(
                            colors: [Colors.white54, Colors.white54]))
                    .createShader(bounds);
              },
              child: Icon(
                isSelected ? activeIcon : icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
