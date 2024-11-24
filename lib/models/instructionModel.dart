class InstructionModel {
  int? id;
  final int recipeId;
  final int stepNumber;
  final String name;
  String? status;

  InstructionModel({
    this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.name,
    this.status,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeId': recipeId,
      'stepNumber': stepNumber,
      'name': name,
      'status': status,
    };
  }

  static List<InstructionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InstructionModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(
      List<InstructionModel> instructions) {
    return instructions.map((instruction) => instruction.toJson()).toList();
  }
}
