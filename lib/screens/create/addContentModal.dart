import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/screens/create/previewContent.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddContentModal {
  static final ImagePicker _picker = ImagePicker();

  static void show(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) => [
        WoltModalSheetPage(
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  iconColor: Colors.white,
                ),
                onPressed: () {
                  openGalleryOrCamera(context, true);
                },
                icon: const Icon(Iconsax.gallery),
                label: const Text(
                  "Abrir Galería",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  iconColor: Colors.white,
                ),
                onPressed: () {
                  openGalleryOrCamera(context, false);
                },
                icon: const Icon(Iconsax.camera),
                label: const Text(
                  "Abrir Cámara",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  static Future<void> openGalleryOrCamera(
      BuildContext context, bool isGallery) async {
    try {
      final XFile? image = await _picker.pickImage(
          source: isGallery ? ImageSource.gallery : ImageSource.camera);
      if (image == null) return;
      String? filePath = image.path;
      if (filePath.isEmpty) return;
      if (context.mounted == false) return;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewContent(
                    imagePath: filePath,
                  )));
    } catch (e) {
      throw Exception('Error opening image: $e');
    }
  }
}
