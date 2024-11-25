import 'dart:convert';

import 'package:myapp/models/userModel.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "https://nutriflow-production.up.railway.app/users";

  Future<UserModel> postData(UserModel user) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/save"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user.toJson()));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return UserModel.fromJson(json.decode(decodedData));
      } else {
        final errorData = utf8.decode(response.bodyBytes);
        print('Error en postData: ${response.statusCode}, Body: $errorData');
        throw Exception("Error al guardar usuario: ${response.reasonPhrase}");
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
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
