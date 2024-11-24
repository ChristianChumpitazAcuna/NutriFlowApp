import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/screens/create/formScreens/createRecipeScreen.dart';
import 'package:myapp/services/storageService.dart';

class PreviewContent extends StatefulWidget {
  final String imagePath;
  const PreviewContent({super.key, required this.imagePath});

  @override
  State<StatefulWidget> createState() => _PreviewContentState();
}

class _PreviewContentState extends State<PreviewContent> {
  final StorageService _storageService = StorageService();

  void _sendContent(BuildContext context) async {
    try {
      if (widget.imagePath.isEmpty) return;

      File file = File(widget.imagePath);

      final imageUrl = await _storageService.uploadImage(file);
      if (imageUrl == null) return;
      if (context.mounted == false) return;

      print(imageUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateRecipeScreen(imageUrl: imageUrl),
        ),
      );
      print('Image URL: $imageUrl');
    } catch (e) {
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              _sendContent(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                File(widget.imagePath), // Muestra la imagen
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
