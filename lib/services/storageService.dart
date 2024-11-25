import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StorageService {
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  Future<String?> uploadImage(File file) async {
    try {
      if (file.existsSync() == false) return null;
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);

      final fileBytes = await file.readAsBytes();
      final filePart = http.MultipartFile.fromBytes('file', fileBytes,
          filename: file.path.split('/').last);

      request.files.add(filePart);
      request.fields['upload_preset'] = 'presetUpload';
      request.fields['resource_type'] = 'raw';

      final response = await request.send();

      if (response.statusCode != 200) return null;

      final responseBody = await response.stream.bytesToString();

      if (responseBody.isEmpty) return null;

      final responseJson = jsonDecode(responseBody);
      final imageUrl = responseJson['secure_url'];
      return imageUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
