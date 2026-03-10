class UserProfileModel {
  int? age;
  double? height;
  double? weight;
  String? gender;
  String? activityLevel;
  String? goal;
  String? weeklyTarget;

  UserProfileModel({
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.activityLevel,
    this.goal = 'Maintenance',
    this.weeklyTarget = '',
  });
}
