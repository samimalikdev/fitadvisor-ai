import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/routes/app_routes.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _floatController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _loaderOpacity;
  late Animation<double> _glowPulse;
  late Animation<double> _orbPulse;
  late Animation<double> _iconRotate;
  late Animation<double> _floatY;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.55, 0.8, curve: Curves.easeIn),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.55, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _orbPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _iconRotate = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    _floatY = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _masterController.forward();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefsService = SharedPrefsService();
    final token = await prefsService.getToken();

    if (token != null && token.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.initial);
    } else {
      await Future.delayed(const Duration(milliseconds: 6000));
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF060818),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF0D1B3E),
                  Color(0xFF060818),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _orbPulse,
            builder: (_, __) => Positioned(
              top: -size.height * 0.1,
              left: -size.width * 0.2,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1565C0)
                          .withValues(alpha: 0.25 * _orbPulse.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _orbPulse,
            builder: (_, __) => Positioned(
              bottom: -size.height * 0.05,
              right: -size.width * 0.15,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF00BFA5)
                          .withValues(alpha: 0.15 * _orbPulse.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _iconRotate,
            builder: (_, __) => Positioned(
              top: size.height * 0.5 - size.width * 0.55,
              left: size.width * 0.5 - size.width * 0.55,
              child: Transform.rotate(
                angle: _iconRotate.value,
                child: Container(
                  width: size.width * 1.1,
                  height: size.width * 1.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2979FF).withValues(alpha: 0.04),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _iconRotate,
            builder: (_, __) => Positioned(
              top: size.height * 0.5 - size.width * 0.42,
              left: size.width * 0.5 - size.width * 0.42,
              child: Transform.rotate(
                angle: -_iconRotate.value * 0.6,
                child: Container(
                  width: size.width * 0.84,
                  height: size.width * 0.84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _masterController,
                    _pulseController,
                    _floatController,
                  ]),
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _floatY.value),
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2979FF).withValues(
                                        alpha: 0.15 * _glowPulse.value),
                                    blurRadius: 60,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2979FF).withValues(
                                      alpha: 0.2 * _glowPulse.value),
                                  width: 1.5,
                                ),
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF1A237E)
                                        .withValues(alpha: 0.6),
                                    const Color(0xFF0D1B3E)
                                        .withValues(alpha: 0.4),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2979FF).withValues(
                                        alpha: 0.5 * _glowPulse.value),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                FadeTransition(
                  opacity: _titleOpacity,
                  child: SlideTransition(
                    position: _titleSlide,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFBBDEFB),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'FitAdvisor AI',
                        style: GoogleFonts.outfit(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _subtitleOpacity,
                  child: SlideTransition(
                    position: _subtitleSlide,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 1,
                          color: const Color(0xFF00BFA5).withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'YOUR PERSONAL AI ASSISTANT',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF80CBC4),
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 20,
                          height: 1,
                          color: const Color(0xFF00BFA5).withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                FadeTransition(
                  opacity: _loaderOpacity,
                  child: _NutritionLoader(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionLoader extends StatefulWidget {
  @override
  State<_NutritionLoader> createState() => _NutritionLoaderState();
}

class _NutritionLoaderState extends State<_NutritionLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.33;
            final t = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = math.sin(t * math.pi).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: 0.5 + (scale * 0.5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      const Color(0xFF2979FF).withValues(alpha: 0.3),
                      const Color(0xFF00BFA5),
                      scale,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2979FF)
                            .withValues(alpha: scale * 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
