class DailyIntakeModel {
  int? calories;
  int? carbohydrates;
  int? fat;
  int? protein;
  String? foodName;

  DailyIntakeModel(
      {this.calories,
      this.carbohydrates,
      this.fat,
      this.protein,
      this.foodName});

  DailyIntakeModel.fromJson(Map<String, dynamic> json) {
    if (json["calories"] is int) {
      calories = json["calories"];
    }
    if (json["carbohydrates"] is int) {
      carbohydrates = json["carbohydrates"];
    }
    if (json["fat"] is int) {
      fat = json["fat"];
    }
    if (json["protein"] is int) {
      protein = json["protein"];
    }
    if (json["foodName"] is String) {
      foodName = json["foodName"];
    }
  }

  static List<DailyIntakeModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(DailyIntakeModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["calories"] = calories;
    data["carbohydrates"] = carbohydrates;
    data["fat"] = fat;
    data["protein"] = protein;
    data["foodName"] = foodName;
    return data;
  }
}
