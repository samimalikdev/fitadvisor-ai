class CalculatedMealModel {
  String? foodName;
  int? calories;
  int? carbohydrates;
  int? fat;
  int? protein;
  String? time;

  CalculatedMealModel(
      {this.foodName,
      this.calories,
      this.carbohydrates,
      this.fat,
      this.protein,
      this.time});

  CalculatedMealModel.fromJson(Map<String, dynamic> json) {
    if (json["foodName"] is String) {
      foodName = json["foodName"];
    }
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
    if (json["time"] is String) {
      time = json["time"];
    }
  }

  static List<CalculatedMealModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CalculatedMealModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["foodName"] = foodName;
    data["calories"] = calories;
    data["carbohydrates"] = carbohydrates;
    data["fat"] = fat;
    data["protein"] = protein;
    data["time"] = time;
    return data;
  }
}
