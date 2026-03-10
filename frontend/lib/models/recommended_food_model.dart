class RecommendedFoodModel {
  List<FoodItems>? foodItems;

  RecommendedFoodModel.fromJson(Map<String, dynamic> json) {
    if (json["foodItems"] != null) {
      foodItems = (json["foodItems"] as List)
          .map((e) => FoodItems.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foodItems != null) {
      data["foodItems"] = foodItems?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class FoodItems {
  String? foodName;
  String? description;

  FoodItems.fromJson(Map<String, dynamic> json) {
    foodName = json["food_name"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["food_name"] = foodName;
    data["description"] = description;
    return data;
  }
}
