import 'dart:io';
import 'package:e_wallet_uts/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImageService _imageService = ImageService();
  final StorageService _storageService = StorageService();
  final ImageFile _imageFile = ImageFile();

  Future<void> _pickImage(bool fromCamera) async {
    try {
      final file = fromCamera
          ? await _imageService.pickFromCamera()
          : await _imageService.pickFromGallery();

      if (file != null) {
        setState(() {
          _imageFile.setImageFile(file);
        });
        await _storageService.saveImagePath(file.path);
        wShowToast(msg: "Gambar berhasil ditambahkan");
      } else {
        wShowToast(msg: "Tidak ada gambar yang ditambahkan");
      }
    } catch (e) {
      wShowToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _imageFile.setImageFile(null);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          wElevatedButtonIcon(
            text: "Galeri",
            icon: Icons.photo_library,
            size: 20,
            onPressed: () => _pickImage(false),
          ),
          wElevatedButtonIcon(
            text: "Kamera",
            icon: Icons.photo_camera,
            size: 20,
            onPressed: () => _pickImage(true),
          ),
        ],
      ),
    );
  }
}

class ImageFile {
  File? imageFile;

  void setImageFile(File? imageFile) {
    this.imageFile = imageFile;
  }

  File? getImageFile() {
    return imageFile;
  }
}
