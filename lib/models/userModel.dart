class UserModel {
  final int? id;
  final String displayName;
  final String avatarUrl;
  final String email;
  final String? status;

  UserModel({
    this.id,
    required this.displayName,
    required this.avatarUrl,
    required this.email,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'email': email,
      'status': status,
    };
  }
}
