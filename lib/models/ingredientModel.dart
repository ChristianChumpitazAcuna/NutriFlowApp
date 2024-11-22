class IngredientModel {
  final int id;
  final int recipeId;
  final String name;
  final String status;

  IngredientModel({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.status,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      recipeId: json['recipeId'],
      name: json['name'],
      status: json['status'],
    );
  }
}
