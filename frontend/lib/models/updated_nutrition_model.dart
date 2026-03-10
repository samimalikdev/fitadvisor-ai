class UpdatedNutritionModel {
  List<Updated>? updated;
  int? amount;

  UpdatedNutritionModel({this.updated, this.amount});

  UpdatedNutritionModel.fromJson(Map<String, dynamic> json) {
    if (json["updated"] is List) {
      updated = json["updated"] == null
          ? null
          : (json["updated"] as List).map((e) => Updated.fromJson(e)).toList();
    }
    if (json["amount"] is int) {
      amount = json["amount"];
    }
  }

  static List<UpdatedNutritionModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UpdatedNutritionModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (updated != null) {
      data["updated"] = updated?.map((e) => e.toJson()).toList();
    }
    data["amount"] = amount;

    return data;
  }
}

class Updated {
  Carbohydrates? carbohydrates;
  Fat? fat;
  Calories? calories;
  Protein? protein;

  Updated({this.carbohydrates, this.fat, this.calories, this.protein});

  Updated.fromJson(Map<String, dynamic> json) {
    if (json["carbohydrates"] is Map) {
      carbohydrates = json["carbohydrates"] == null
          ? null
          : Carbohydrates.fromJson(json["carbohydrates"]);
    }
    if (json["fat"] is Map) {
      fat = json["fat"] == null ? null : Fat.fromJson(json["fat"]);
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

  static List<Updated> fromList(List<Map<String, dynamic>> list) {
    return list.map(Updated.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carbohydrates != null) {
      data["carbohydrates"] = carbohydrates?.toJson();
    }
    if (fat != null) {
      data["fat"] = fat?.toJson();
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

  Protein({this.value});

  Protein.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
  }

  static List<Protein> fromList(List<Map<String, dynamic>> list) {
    return list.map(Protein.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    return data;
  }
}

class Calories {
  int? value;

  Calories({this.value});

  Calories.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
  }

  static List<Calories> fromList(List<Map<String, dynamic>> list) {
    return list.map(Calories.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    return data;
  }
}

class Fat {
  int? value;

  Fat({this.value});

  Fat.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
  }

  static List<Fat> fromList(List<Map<String, dynamic>> list) {
    return list.map(Fat.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    return data;
  }
}

class Carbohydrates {
  int? value;

  Carbohydrates({this.value});

  Carbohydrates.fromJson(Map<String, dynamic> json) {
    if (json["value"] is int) {
      value = json["value"];
    }
  }

  static List<Carbohydrates> fromList(List<Map<String, dynamic>> list) {
    return list.map(Carbohydrates.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    return data;
  }
}
