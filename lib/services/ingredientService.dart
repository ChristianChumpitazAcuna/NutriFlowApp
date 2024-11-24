import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/ingredientModel.dart';

class IngredientService {
  final String baseUrl =
      "https://nutriflow-production.up.railway.app/ingredients";

  Future<List<IngredientModel>> getData(String status) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/list/$status"),
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        List<dynamic> body = json.decode(decodedData);
        List<IngredientModel> recipes =
            body.map((dynamic item) => IngredientModel.fromJson(item)).toList();
        return recipes;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<IngredientModel>> postData(
      List<IngredientModel> ingredients) async {
    try {
      final reponse = await http.post(Uri.parse("$baseUrl/save"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(IngredientModel.toJsonList(ingredients)));

      if (reponse.statusCode == 201) {
        final String decodedData = utf8.decode(reponse.bodyBytes);
        return IngredientModel.fromJsonList(json.decode(decodedData));
      } else {
        throw Exception("Failed to save data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<IngredientModel> updateData(int id, IngredientModel ingredient) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/update/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return IngredientModel.fromJson(json.decode(decodedData));
      } else {
        throw Exception("Failed to update data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> changeStatus(int id, String status) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/$status/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print("Ingredient deleted successfully");
      } else {
        throw Exception("Failed to delete data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
