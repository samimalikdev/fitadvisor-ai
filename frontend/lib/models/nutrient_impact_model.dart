class NutrientImpactModel {
  String? title;
  String? healthImpact;
  int? value;
  String? dvPercentage;
  String? reason;

  NutrientImpactModel(
      {this.title,
      this.healthImpact,
      this.value,
      this.dvPercentage,
      this.reason});

  NutrientImpactModel.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["health_impact"] is String) {
      healthImpact = json["health_impact"];
    }
    if (json["value"] is int) {
      value = json["value"];
    }
    if (json["dv_percentage"] is String) {
      dvPercentage = json["dv_percentage"];
    }
    if (json["reason"] is String) {
      reason = json["reason"];
    }
  }

  static List<NutrientImpactModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NutrientImpactModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["health_impact"] = healthImpact;
    data["value"] = value;
    data["dv_percentage"] = dvPercentage;
    data["reason"] = reason;
    return data;
  }
}
