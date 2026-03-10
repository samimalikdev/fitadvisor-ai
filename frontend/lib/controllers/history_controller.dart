import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_ai/models/daily_log_model.dart';
import 'package:nutrition_ai/services/api_controller.dart';
import 'package:nutrition_ai/utils/snackbar_helper.dart';

class HistoryController extends GetxController {
  final ApiController _apiController = ApiController();

  final RxMap<DateTime, DailyLogModel> _dailyLogs =
      <DateTime, DailyLogModel>{}.obs;

  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  DailyLogModel? getLogForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _dailyLogs[normalizedDay];
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final List<dynamic> rawLogs = await _apiController.get('/history');
      _dailyLogs.clear();

      for (var item in rawLogs) {
        try {
          final log = DailyLogModel.fromJson(item);
          final parsedDate = DateFormat('yyyy-MM-dd').parse(log.date);
          final normalizedDate =
              DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
          _dailyLogs[normalizedDate] = log;
        } catch (e) {
          print("Date parse error for log: \$e");
        }
      }

      if (_dailyLogs.isEmpty) {
        SnackbarHelper.showError(
            "Debug", "Fetched ${rawLogs.length} logs but 0 dates parsed.");
      } else {
        SnackbarHelper.showSuccess(
            "Debug", "Showing ${_dailyLogs.length} days of history.");
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "Could not load history: \$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveTestLog(DailyLogModel log) async {
    try {
      await _apiController.post('/history/log_day', log.toJson());
      await fetchHistory();
    } catch (e) {
      print("Error saving daily log: \$e");
      SnackbarHelper.showError("Network Error", "Could not save log.");
    }
  }
}
