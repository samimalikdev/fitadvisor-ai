import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntakeProgressCard extends StatelessWidget {
  final String title;
  final int min;
  final int max;
  final String unit;
  final Color color;
  const IntakeProgressCard({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.unit,
    this.color = const Color(0xFF2979FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
            ),
            child: Center(
              child: Icon(
                _getIconForTitle(title),
                color: color,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$min / $max $unit',
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (max > 0) ? (min / max).clamp(0.0, 1.0) : 0.0,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          )
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'protein':
        return Icons.fitness_center;
      case 'carbs':
        return Icons.rice_bowl;
      case 'fat':
        return Icons.water_drop;
      default:
        return Icons.fastfood;
    }
  }
}
