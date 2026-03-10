import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrition_ai/controllers/profile_controller.dart';
import 'package:nutrition_ai/controllers/daily_intake_controller.dart';

class WaterIntakeScreen extends StatefulWidget {
  @override
  _WaterIntakeScreenState createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends State<WaterIntakeScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  final DailyIntakeController dailyIntakeController =
      Get.put(DailyIntakeController());

  bool _takesCreatine = false;
  bool _takesPreWorkout = false;
  double _exerciseDurationHours = 0.0;

  double _calculatedWaterMl = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _calculateWater();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateWater() {
    double baseWaterMl = 2500;

    final weight = profileController.userProfile.value.weight;
    if (weight != null && weight > 0) {
      baseWaterMl = weight * 35.0;
    }

    int targetProtein = 0;
    if (dailyIntakeController.dailyIntakeModel.isNotEmpty) {
      targetProtein = dailyIntakeController.dailyIntakeModel.first.protein ?? 0;
    }
    if (targetProtein > 150) {
      baseWaterMl += 500;
    }

    if (_takesCreatine) {
      baseWaterMl += 500;
    }
    if (_takesPreWorkout) {
      baseWaterMl += 250;
    }

    baseWaterMl += (_exerciseDurationHours * 500);

    setState(() {
      _calculatedWaterMl = baseWaterMl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        title: Text(
          'Hydration Goals',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWaterDisplay(),
              const SizedBox(height: 50),
              Text(
                'Customize Daily Factors',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              _buildToggleOption(
                title: 'Creatine Supplement',
                subtitle: '+500 ml for optimal muscle hydration',
                value: _takesCreatine,
                onChanged: (val) {
                  setState(() => _takesCreatine = val);
                  _calculateWater();
                },
                icon: FontAwesomeIcons.pills,
                gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              ),
              const SizedBox(height: 16),
              _buildToggleOption(
                title: 'Pre-Workout Drink',
                subtitle: '+250 ml to maintain hydration levels',
                value: _takesPreWorkout,
                onChanged: (val) {
                  setState(() => _takesPreWorkout = val);
                  _calculateWater();
                },
                icon: FontAwesomeIcons.bolt,
                gradientColors: [Color(0xFFFF512F), Color(0xFFDD2476)],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Exercise Duration',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '+${(_exerciseDurationHours * 500).toInt()} ml',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00E676),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E24),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      '${_exerciseDurationHours.toStringAsFixed(1)} Hours Active',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF00E676),
                        inactiveTrackColor: Colors.white12,
                        thumbColor: Colors.white,
                        overlayColor:
                            const Color(0xFF00E676).withValues(alpha: 0.2),
                        trackHeight: 6.0,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 24.0),
                      ),
                      child: Slider(
                        value: _exerciseDurationHours,
                        min: 0,
                        max: 4,
                        divisions: 8,
                        onChanged: (val) {
                          setState(() => _exerciseDurationHours = val);
                          _calculateWater();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoBox(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterDisplay() {
    double liters = _calculatedWaterMl / 1000.0;

    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF00C6FF).withValues(alpha: 0.8),
                  const Color(0xFF0072FF).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0072FF).withValues(
                      alpha: 0.4 + (_animationController.value * 0.2)),
                  blurRadius: 40 + (_animationController.value * 20),
                  spreadRadius: 10 + (_animationController.value * 5),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: -5,
                )
              ],
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.droplet,
              color: Colors.white.withValues(alpha: 0.9),
              size: 45,
            ),
            const SizedBox(height: 15),
            Text(
              '${liters.toStringAsFixed(1)} L',
              style: GoogleFonts.outfit(
                fontSize: 54,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Daily Target',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: value
            ? gradientColors.last.withValues(alpha: 0.1)
            : const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value
              ? gradientColors.first.withValues(alpha: 0.5)
              : Colors.white12,
          width: 1.5,
        ),
        boxShadow: value
            ? [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors.last.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: gradientColors.first,
            inactiveTrackColor: Colors.white12,
            inactiveThumbColor: Colors.white54,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0072FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0072FF).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0072FF).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(FontAwesomeIcons.circleInfo,
                color: const Color(0xFF00C6FF), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Base calculation is ~35ml per kg of your stored body weight, plus additional allowances for high protein intake in your plan.',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
