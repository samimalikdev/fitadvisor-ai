class RecipeModel {
  String? recipeName;
  String? description;
  List<String>? ingredients;
  List<String>? instructions;
  RecipeNutrition? nutrition;

  RecipeModel({
    this.recipeName,
    this.description,
    this.ingredients,
    this.instructions,
    this.nutrition,
  });

  RecipeModel.fromJson(Map<String, dynamic> json) {
    recipeName = json['recipeName'];
    description = json['description'];
    if (json['ingredients'] != null) {
      ingredients = List<String>.from(json['ingredients']);
    }
    if (json['instructions'] != null) {
      instructions = List<String>.from(json['instructions']);
    }
    nutrition = json['nutrition'] != null
        ? RecipeNutrition.fromJson(json['nutrition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recipeName'] = recipeName;
    data['description'] = description;
    data['ingredients'] = ingredients;
    data['instructions'] = instructions;
    if (nutrition != null) {
      data['nutrition'] = nutrition!.toJson();
    }
    return data;
  }
}

class RecipeNutrition {
  int? calories;
  int? carbohydrates;
  int? fat;
  int? protein;

  RecipeNutrition({this.calories, this.carbohydrates, this.fat, this.protein});

  RecipeNutrition.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    carbohydrates = json['carbohydrates'];
    fat = json['fat'];
    protein = json['protein'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calories'] = calories;
    data['carbohydrates'] = carbohydrates;
    data['fat'] = fat;
    data['protein'] = protein;
    return data;
  }
}
