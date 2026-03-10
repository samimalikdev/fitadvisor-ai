import 'package:get/get.dart';
import 'package:nutrition_ai/routes/app_routes.dart';
import 'package:nutrition_ai/services/shared_prefs_service.dart';

class SettingsController extends GetxController {
  final SharedPrefsService _prefsService = SharedPrefsService();

  Future<void> logout() async {
    await _prefsService.clearAll();
    Get.offAllNamed(AppRoutes.login);
  }
}
