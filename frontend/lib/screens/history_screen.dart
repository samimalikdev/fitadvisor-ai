import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_ai/controllers/history_controller.dart';
import 'package:nutrition_ai/models/daily_log_model.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'Nutrition History',
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent));
        }

        return Column(
          children: [
            _buildCalendar(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildDailyDetails(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) =>
            isSameDay(controller.selectedDay.value, day),
        onDaySelected: controller.onDaySelected,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.poppins(color: Colors.white70),
          weekendStyle: GoogleFonts.poppins(color: Colors.blueAccent),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: Colors.white),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) =>
              _buildCalendarCell(day, false),
          selectedBuilder: (context, day, focusedDay) =>
              _buildCalendarCell(day, true),
          todayBuilder: (context, day, focusedDay) => _buildCalendarCell(
              day, isSameDay(controller.selectedDay.value, day),
              isToday: true),
          markerBuilder: (context, day, events) {
            final log = controller.getLogForDay(day);
            if (log != null) {
              return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          log.macrosHit ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCalendarCell(DateTime day, bool isSelected,
      {bool isToday = false}) {
    final log = controller.getLogForDay(day);

    Color? bgColor;
    Color borderColor = Colors.transparent;

    if (isSelected) {
      bgColor = const Color(0xFF2979FF).withValues(alpha: 0.3);
      borderColor = const Color(0xFF2979FF);
    } else if (log != null) {
      bgColor = log.macrosHit
          ? Colors.greenAccent.withValues(alpha: 0.1)
          : Colors.redAccent.withValues(alpha: 0.1);
      borderColor = log.macrosHit
          ? Colors.greenAccent.withValues(alpha: 0.3)
          : Colors.redAccent.withValues(alpha: 0.3);
    } else if (isToday) {
      borderColor = Colors.white54;
    }

    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDailyDetails() {
    final selectedLog = controller.getLogForDay(controller.selectedDay.value);

    if (selectedLog == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off,
                size: 60, color: Colors.white.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              "No logs for this date.",
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 52),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMacroSummary(selectedLog),
          const SizedBox(height: 24),
          Text(
            "Meals Eaten",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...selectedLog.meals.map((meal) => _buildMealCard(meal)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMacroSummary(DailyLogModel log) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: log.macrosHit
                  ? [Colors.green.shade800, Colors.teal.shade900]
                  : [Colors.red.shade900, Colors.deepOrange.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: log.macrosHit
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 10,
              )
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  log.macrosHit ? "Target Hit!" : "Missed Target",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Icon(log.macrosHit ? Icons.check_circle : Icons.warning,
                    color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _macroStat("Calories", log.consumedMacros.calories,
                    log.targetMacros.calories, 'kcal'),
                _macroStat("Protein", log.consumedMacros.protein,
                    log.targetMacros.protein, 'g'),
                _macroStat("Carbs", log.consumedMacros.carbs,
                    log.targetMacros.carbs, 'g'),
                _macroStat(
                    "Fat", log.consumedMacros.fat, log.targetMacros.fat, 'g'),
              ],
            )
          ],
        ));
  }

  Widget _macroStat(String label, int consumed, int target, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          "$consumed",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "/ $target$unit",
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMealCard(Meal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  meal.name,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                if (meal.time != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(meal.time!),
                    style: GoogleFonts.poppins(
                        color: Colors.blueAccent, fontSize: 12),
                  ),
                ]
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            "${meal.calories} kcal",
            style: GoogleFonts.poppins(
                color: Colors.orangeAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
