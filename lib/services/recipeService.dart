import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/dto/recipeDto.dart';

class RecipeService {
  final String baseUrl = "https://nutriflow-production.up.railway.app/recipes";

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
}
