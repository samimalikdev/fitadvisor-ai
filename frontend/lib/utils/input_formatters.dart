import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int? parsedValue = int.tryParse(newValue.text);
    if (parsedValue != null && parsedValue > maxValue) {
      return oldValue;
    }
    return newValue;
  }
}
