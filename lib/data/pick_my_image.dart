import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickMyImage {
  static Future<File?> getImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1500,
      maxWidth: 1500,
    );
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
