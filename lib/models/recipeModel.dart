class RecipeModel {
  int? id;
  int? userId;
  final String name;
  final String description;
  final String time;
  final int servings;
  final String imageUrl;
  String? status;

  RecipeModel({
    this.id,
    this.userId,
    required this.name,
    required this.description,
    required this.time,
    required this.servings,
    required this.imageUrl,
    this.status,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      time: json['time'] as String? ?? '',
      servings: json['servings'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'time': time,
      'servings': servings,
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}
