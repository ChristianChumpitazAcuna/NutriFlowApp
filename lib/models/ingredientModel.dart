class IngredientModel {
  int? id;
  final int recipeId;
  final String name;
  String? status;

  IngredientModel({
    this.id,
    required this.recipeId,
    required this.name,
    this.status,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'],
      recipeId: json['recipeId'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeId': recipeId,
      'name': name,
      'status': status,
    };
  }

  static List<IngredientModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => IngredientModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(
      List<IngredientModel> ingredients) {
    return ingredients.map((ingredient) => ingredient.toJson()).toList();
  }
}
