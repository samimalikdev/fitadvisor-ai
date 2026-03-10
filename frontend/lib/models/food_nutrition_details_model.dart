class FoodNutritionDetailsModel {
  String? description;
  String? reasonOfCarbs;
  String? reasonOfFat;
  String? reasonOfFiber;
  String? reasonOfCalories;
  String? reasonOfProtein;
  String? reasonOfSodium;
  String? reasonOfSaturatedFat;

  FoodNutritionDetailsModel(
      {this.description,
      this.reasonOfCarbs,
      this.reasonOfFat,
      this.reasonOfFiber,
      this.reasonOfCalories,
      this.reasonOfProtein,
      this.reasonOfSodium,
      this.reasonOfSaturatedFat});

  FoodNutritionDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["reason_of_carbs"] is String) {
      reasonOfCarbs = json["reason_of_carbs"];
    }
    if (json["reason_of_fat"] is String) {
      reasonOfFat = json["reason_of_fat"];
    }
    if (json["reason_of_fiber"] is String) {
      reasonOfFiber = json["reason_of_fiber"];
    }
    if (json["reason_of_calories"] is String) {
      reasonOfCalories = json["reason_of_calories"];
    }
    if (json["reason_of_protein"] is String) {
      reasonOfProtein = json["reason_of_protein"];
    }
    if (json["reason_of_sodium"] is String) {
      reasonOfSodium = json["reason_of_sodium"];
    }
    if (json["reason_of_saturated_fat"] is String) {
      reasonOfSaturatedFat = json["reason_of_saturated_fat"];
    }
  }

  static List<FoodNutritionDetailsModel> fromList(
      List<Map<String, dynamic>> list) {
    return list.map(FoodNutritionDetailsModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["description"] = description;
    data["reason_of_carbs"] = reasonOfCarbs;
    data["reason_of_fat"] = reasonOfFat;
    data["reason_of_fiber"] = reasonOfFiber;
    data["reason_of_calories"] = reasonOfCalories;
    data["reason_of_protein"] = reasonOfProtein;
    data["reason_of_sodium"] = reasonOfSodium;
    data["reason_of_saturated_fat"] = reasonOfSaturatedFat;
    return data;
  }
}
