class InstructionModel {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String name;
  final String status;

  InstructionModel({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.name,
    required this.status,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      id: json['id'],
      recipeId: json['recipeId'],
      stepNumber: json['stepNumber'],
      name: json['name'],
      status: json['status'],
    );
  }
}
