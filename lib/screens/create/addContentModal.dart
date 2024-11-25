import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/create/previewContent.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddContentModal {
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
                  openFilePicker(context);
                },
                icon: const Icon(Icons.photo_library),
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
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.camera_alt),
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

  static Future<void> openFilePicker(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          allowedExtensions: ['jpg', 'png'],
          type: FileType.custom);

      if (result == null) return;
      String? filePath = result.files.single.path;
      if (filePath == null || filePath.isEmpty) return;
      if (context.mounted == false) return;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewContent(
                    imagePath: filePath,
                  )));
    } catch (e) {
      throw Exception('Error al abrir la galería: $e');
    }
  }
}
