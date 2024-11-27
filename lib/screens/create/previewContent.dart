import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/screens/create/forms/recipeScreen.dart';
import 'package:myapp/services/notificationService.dart';
import 'package:myapp/services/storageService.dart';
import 'package:toastification/toastification.dart';

class PreviewContent extends StatefulWidget {
  final String imagePath;
  const PreviewContent({super.key, required this.imagePath});

  @override
  State<StatefulWidget> createState() => _PreviewContentState();
}

class _PreviewContentState extends State<PreviewContent> {
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = false;

  void _sendContent(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (widget.imagePath.isEmpty) return;
      File file = File(widget.imagePath);

      final imageUrl = await _storageService.uploadImage(file);
      if (imageUrl == null) return;
      if (context.mounted == false) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeScreen(imageUrl: imageUrl),
        ),
      );
    } catch (e) {
      _notificationService.showNotification(
          context: context,
          message: 'Error: $e',
          type: ToastificationType.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWight = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Image.file(
                width: screenWight,
                File(widget.imagePath), // Muestra la imagen
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
                top: 30,
                right: 10,
                bottom: 0,
                child: Column(
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          _sendContent(context);
                        },
                        icon: const Icon(
                          Iconsax.send_2,
                          color: Colors.white,
                        )),
                    IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Iconsax.arrow_left,
                          color: Colors.white,
                        )),
                  ],
                )),
            if (_isLoading)
              Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Widget de animación de carga
                  Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ));
  }
}
