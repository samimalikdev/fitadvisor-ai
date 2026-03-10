import 'package:get/get.dart';
import 'package:nutrition_ai/screens/bottom_nav_bar.dart';
import 'package:nutrition_ai/screens/home_screen.dart';
import 'package:nutrition_ai/screens/ask_nutrition_manager_screen.dart';
import 'package:nutrition_ai/screens/login_screen.dart';
import 'package:nutrition_ai/screens/scan_label_screen.dart';
import 'package:nutrition_ai/screens/profile_screen.dart';
import 'package:nutrition_ai/screens/history_screen.dart';
import 'package:nutrition_ai/screens/daily_intake_overwiew_screen.dart';
import 'package:nutrition_ai/screens/recipe_generator_screen.dart';
import 'package:nutrition_ai/screens/water_intake_screen.dart';
import 'package:nutrition_ai/screens/settings_screen.dart';
import 'package:nutrition_ai/screens/edit_profile_screen.dart';
import 'package:nutrition_ai/screens/app_info_screen.dart';
import 'package:nutrition_ai/screens/terms_of_service_screen.dart';
import 'package:nutrition_ai/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String initial = '/';
  static const String home = '/home';
  static const String askNutritionManager = '/ask-nutrition-manager';
  static const String scanLabel = '/scan-label';
  static const String scanFood = '/scan-food';
  static const String profile = '/profile';
  static const String dailyIntakeOverview = '/daily-intake-overview';
  static const String history = '/history';
  static const String recipeGenerator = '/recipe-generator';
  static const String waterIntake = '/water-intake';
  static const String login = '/login';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String appInfo = '/app-info';
  static const String termsOfService = '/terms-of-service';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: initial,
      page: () => BottomNavScreen(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: askNutritionManager,
      page: () => AskNutritionManagerScreen(),
    ),
    GetPage(
      name: scanLabel,
      page: () => ScanLabelScreen(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: dailyIntakeOverview,
      page: () => DailyIntakeOverviewScreen(),
    ),
    GetPage(
      name: history,
      page: () => HistoryScreen(),
    ),
    GetPage(
      name: recipeGenerator,
      page: () => RecipeGeneratorScreen(),
    ),
    GetPage(
      name: waterIntake,
      page: () => WaterIntakeScreen(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: editProfile,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: appInfo,
      page: () => const AppInfoScreen(),
    ),
    GetPage(
      name: termsOfService,
      page: () => const TermsOfServiceScreen(),
    ),
  ];
}
