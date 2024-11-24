import 'dart:convert';

import 'package:myapp/models/userModel.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://nutriflow-production.up.railway.app/users";

  Future<UserModel> postData(UserModel user) async {
    try {
      final reponse = await http.post(Uri.parse("$baseUrl/save"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toJson()));

      if (reponse.statusCode == 201) {
        final String decodedData = utf8.decode(reponse.bodyBytes);
        return UserModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<UserModel?> findByEmail(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/findByEmail/$email"));

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return UserModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error while fetching user: $e");
      rethrow;
    }
  }
}
