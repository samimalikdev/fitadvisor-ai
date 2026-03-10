import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/utils/input_formatters.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.keyboardType,
    required this.controller,
    this.maxValue = 0,
    this.isText = false,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final int maxValue;
  final bool isText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: isText
              ? null
              : [
                  FilteringTextInputFormatter.digitsOnly,
                  MaxValueInputFormatter(maxValue),
                ],
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}
