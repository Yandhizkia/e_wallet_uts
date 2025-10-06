import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('image_path', path);
  }

  Future<File?> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('image_path');
    if (path != null) {
      return File(path);
    }
    return null;
  }
}
