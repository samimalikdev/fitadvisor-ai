class DailyLogModel {
  final String date;
  final Macros targetMacros;
  final Macros consumedMacros;
  final bool macrosHit;
  final List<Meal> meals;

  DailyLogModel({
    required this.date,
    required this.targetMacros,
    required this.consumedMacros,
    required this.macrosHit,
    required this.meals,
  });

  factory DailyLogModel.fromJson(Map<String, dynamic> json) {
    return DailyLogModel(
      date: json['date'] as String,
      targetMacros: json['targetMacros'] != null
          ? Macros.fromJson(json['targetMacros'])
          : Macros(calories: 0, protein: 0, carbs: 0, fat: 0),
      consumedMacros: json['consumedMacros'] != null
          ? Macros.fromJson(json['consumedMacros'])
          : Macros(calories: 0, protein: 0, carbs: 0, fat: 0),
      macrosHit: json['macrosHit'] as bool? ?? false,
      meals: (json['meals'] as List<dynamic>?)
              ?.map((meal) => Meal.fromJson(meal as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'targetMacros': targetMacros.toJson(),
      'consumedMacros': consumedMacros.toJson(),
      'macrosHit': macrosHit,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}

class Macros {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Macros({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Macros.fromJson(Map<String, dynamic> json) {
    return Macros(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}

class Meal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime? time;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.time,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['name'] as String? ?? 'Unknown Meal',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      time: json['time'] != null
          ? DateTime.tryParse(json['time'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'time': time?.toIso8601String(),
    };
  }
}
