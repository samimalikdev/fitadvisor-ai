class NutritionModel {
  Label? label;

  NutritionModel({this.label});

  NutritionModel.fromJson(Map<String, dynamic> json) {
    if (json["label"] is Map) {
      label = json["label"] == null ? null : Label.fromJson(json["label"]);
    }
  }

  static List<NutritionModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NutritionModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (label != null) {
      data["label"] = label?.toJson();
    }
    return data;
  }
}

class Label {
  String? mealName;
  String? foodName;
  EstimatedQuantity? estimatedQuantity;
  Carbohydrates? carbohydrates;
  Fat? fat;
  Fiber? fiber;
  Sodium? sodium;
  SaturatedFat? saturatedFat;
  Calories? calories;
  Protein? protein;

  Label(
      {this.mealName,
      this.foodName,
      this.estimatedQuantity,
      this.carbohydrates,
      this.fat,
      this.fiber,
      this.sodium,
      this.saturatedFat,
      this.calories,
      this.protein});

  Label.fromJson(Map<String, dynamic> json) {
    if (json["meal_name"] is String) {
      mealName = json["meal_name"];
    }
    if (json["food_name"] is String) {
      foodName = json["food_name"];
    }
    if (json["estimated_quantity"] is Map) {
      estimatedQuantity = json["estimated_quantity"] == null
          ? null
          : EstimatedQuantity.fromJson(json["estimated_quantity"]);
    }
    if (json["carbohydrates"] is Map) {
      carbohydrates = json["carbohydrates"] == null
          ? null
          : Carbohydrates.fromJson(json["carbohydrates"]);
    }
    if (json["fat"] is Map) {
      fat = json["fat"] == null ? null : Fat.fromJson(json["fat"]);
    }
    if (json["fiber"] is Map) {
      fiber = json["fiber"] == null ? null : Fiber.fromJson(json["fiber"]);
    }
    if (json["sodium"] is Map) {
      sodium = json["sodium"] == null ? null : Sodium.fromJson(json["sodium"]);
    }
    if (json["saturated_fat"] is Map) {
      saturatedFat = json["saturated_fat"] == null
          ? null
          : SaturatedFat.fromJson(json["saturated_fat"]);
    }
    if (json["calories"] is Map) {
      calories =
          json["calories"] == null ? null : Calories.fromJson(json["calories"]);
    }
    if (json["protein"] is Map) {
      protein =
          json["protein"] == null ? null : Protein.fromJson(json["protein"]);
    }
  }

  static List<Label> fromList(List<Map<String, dynamic>> list) {
    return list.map(Label.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["meal_name"] = mealName;
    data["food_name"] = foodName;
    if (estimatedQuantity != null) {
      data["estimated_quantity"] = estimatedQuantity?.toJson();
    }
    if (carbohydrates != null) {
      data["carbohydrates"] = carbohydrates?.toJson();
    }
    if (fat != null) {
      data["fat"] = fat?.toJson();
    }
    if (fiber != null) {
      data["fiber"] = fiber?.toJson();
    }
    if (sodium != null) {
      data["sodium"] = sodium?.toJson();
    }
    if (saturatedFat != null) {
      data["saturated_fat"] = saturatedFat?.toJson();
    }
    if (calories != null) {
      data["calories"] = calories?.toJson();
    }
    if (protein != null) {
      data["protein"] = protein?.toJson();
    }
    return data;
  }
}

class Protein {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Protein({this.value, this.dvPercentage, this.healthImpact});

  Protein.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Protein> fromList(List<Map<String, dynamic>> list) {
    return list.map(Protein.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class Calories {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Calories({this.value, this.dvPercentage, this.healthImpact});

  Calories.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Calories> fromList(List<Map<String, dynamic>> list) {
    return list.map(Calories.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class SaturatedFat {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  SaturatedFat({this.value, this.dvPercentage, this.healthImpact});

  SaturatedFat.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<SaturatedFat> fromList(List<Map<String, dynamic>> list) {
    return list.map(SaturatedFat.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class Sodium {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Sodium({this.value, this.dvPercentage, this.healthImpact});

  Sodium.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Sodium> fromList(List<Map<String, dynamic>> list) {
    return list.map(Sodium.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class Fiber {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Fiber({this.value, this.dvPercentage, this.healthImpact});

  Fiber.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Fiber> fromList(List<Map<String, dynamic>> list) {
    return list.map(Fiber.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class Fat {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Fat({this.value, this.dvPercentage, this.healthImpact});

  Fat.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Fat> fromList(List<Map<String, dynamic>> list) {
    return list.map(Fat.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class Carbohydrates {
  int? value;
  String? dvPercentage;
  String? healthImpact;

  Carbohydrates({this.value, this.dvPercentage, this.healthImpact});

  Carbohydrates.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
  }

  static List<Carbohydrates> fromList(List<Map<String, dynamic>> list) {
    return list.map(Carbohydrates.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["health_impact"] = healthImpact;
    return data;
  }
}

class EstimatedQuantity {
  int? amount;
  String? unit;

  EstimatedQuantity({this.amount, this.unit});

  EstimatedQuantity.fromJson(Map<String, dynamic> json) {
    if (json["amount"] is int) {
      amount = json["amount"];
    }
    if (json["unit"] is String) {
      unit = json["unit"];
    }
  }

  static List<EstimatedQuantity> fromList(List<Map<String, dynamic>> list) {
    return list.map(EstimatedQuantity.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["amount"] = amount;
    data["unit"] = unit;
    return data;
  }
}
