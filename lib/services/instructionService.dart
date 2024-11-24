import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/models/instructionModel.dart';

class InstructionService {
  final String baseUrl =
      "https://nutriflow-production.up.railway.app/instructions";

  Future<List<InstructionModel>> getData(String status) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/list/$status"),
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        List<dynamic> body = json.decode(decodedData);
        List<InstructionModel> recipes = body
            .map((dynamic item) => InstructionModel.fromJson(item))
            .toList();
        return recipes;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<InstructionModel>> postData(
      List<InstructionModel> instructions) async {
    try {
      final reponse = await http.post(Uri.parse("$baseUrl/save"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(InstructionModel.toJsonList(instructions)));

      if (reponse.statusCode == 201) {
        final String decodedData = utf8.decode(reponse.bodyBytes);
        return InstructionModel.fromJsonList(json.decode(decodedData));
      } else {
        throw Exception("Failed to save data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<InstructionModel> updateData(
      int id, InstructionModel instruction) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/update/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String decodedData = utf8.decode(response.bodyBytes);
        return InstructionModel.fromJson(json.decode(decodedData));
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
        print("instruction deleted successfully");
      } else {
        throw Exception("Failed to delete data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
