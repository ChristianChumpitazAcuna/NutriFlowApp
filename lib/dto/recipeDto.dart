import 'package:myapp/models/ingredientModel.dart';
import 'package:myapp/models/instructionModel.dart';
import 'package:myapp/models/userModel.dart';

class RecipeDto {
  final int id;
  final UserModel userId;
  final String name;
  final String description;
  final String time;
  final int servings;
  final String imageUrl;
  final List<IngredientModel> ingredients;
  final List<InstructionModel> instructions;
  final String status;

  RecipeDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.time,
    required this.servings,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.status,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    return RecipeDto(
      id: json['id'],
      userId: UserModel.fromJson(json['userId']),
      name: json['name'],
      description: json['description'],
      time: json['time'],
      servings: json['servings'],
      imageUrl: json['imageUrl'],
      ingredients: (json['ingredients'] as List)
          .map((i) => IngredientModel.fromJson(i))
          .toList(),
      instructions: (json['instructions'] as List)
          .map((i) => InstructionModel.fromJson(i))
          .toList(),
      status: json['status'],
    );
  }
}
