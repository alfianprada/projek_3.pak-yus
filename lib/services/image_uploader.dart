import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:html/parser.dart' as html_parser;

class ImageUploader {
  /// Mengambil gambar dari URL (langsung atau tidak langsung), upload ke Firebase Storage,
  /// lalu return URL download-nya.
  static Future<String> uploadFromUrl(String imageUrl) async {
    try {
      String finalImageUrl = imageUrl;

      // Kalau link bukan langsung file gambar
      if (!imageUrl.endsWith(".jpg") &&
          !imageUrl.endsWith(".png") &&
          !imageUrl.endsWith(".jpeg") &&
          !imageUrl.endsWith(".gif") &&
          !imageUrl.endsWith(".webp")) {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final document = html_parser.parse(response.body);
          final metaImage = document
              .querySelector('meta[property="og:image"]')
              ?.attributes['content'];
          if (metaImage != null && metaImage.isNotEmpty) {
            finalImageUrl = metaImage;
          }
        }
      }

      // Download gambar
      final imgResponse = await http.get(Uri.parse(finalImageUrl));
      if (imgResponse.statusCode != 200) {
        throw Exception("Gagal mengunduh gambar");
      }

      Uint8List imageBytes = imgResponse.bodyBytes;

      // Upload ke Firebase Storage
      String fileName =
          "images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final storageRef =
          FirebaseStorage.instance.ref().child(fileName);

      await storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Upload gagal: $e");
      return 'https://via.placeholder.com/150';
    }
  }
}
