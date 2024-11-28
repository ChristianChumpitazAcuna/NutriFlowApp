import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/dto/recipeDto.dart';
import 'package:myapp/models/recipeModel.dart';

class RecipeService {
  final String baseUrl = "https://nutriflow-production.up.railway.app/recipes";

  Future<List<RecipeDto>> getByUser(int userId, String status) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/list/$status/user/$userId"),
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        List<dynamic> body = json.decode(decodedData);
        List<RecipeDto> recipes =
            body.map((dynamic item) => RecipeDto.fromJson(item)).toList();
        return recipes;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<RecipeDto>> getData(String status) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/list/$status"),
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        List<dynamic> body = json.decode(decodedData);
        List<RecipeDto> recipes =
            body.map((dynamic item) => RecipeDto.fromJson(item)).toList();
        return recipes;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<RecipeModel> postData(RecipeModel recipe) async {
    try {
      final reponse = await http.post(Uri.parse("$baseUrl/save"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(recipe.toJson()));

      if (reponse.statusCode == 201) {
        final String decodedData = utf8.decode(reponse.bodyBytes);
        return RecipeModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("Failed to save data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<RecipeModel> updateData(int id, RecipeModel recipe) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/update/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return RecipeModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("Failed to update data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<RecipeModel> changeStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$status/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return RecipeModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("Failed to update data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
