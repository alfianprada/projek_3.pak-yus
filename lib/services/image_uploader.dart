import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http; // paket http untuk melakukan request GET/HEAD
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage SDK
import 'package:html/parser.dart' as html_parser; // untuk parsing HTML (mencari og:image)

class ImageUploader {
  /// Mengambil gambar dari URL (bisa berupa halaman HTML atau link langsung ke file gambar),
  /// lalu mengupload-nya ke Firebase Storage, dan mengembalikan URL download.
  /// 
  /// Kembalian:
  /// - URL string gambar yang diupload di Firebase Storage.
  /// - Jika terjadi kesalahan, saat ini fungsi mengembalikan placeholder image URL.
  static Future<String> uploadFromUrl(String imageUrl) async {
    try {
      // finalImageUrl: URL yang akan di-download (bisa diganti jika halaman memiliki og:image)
      String finalImageUrl = imageUrl;

      // Jika URL tampak bukan langsung file gambar (cek berdasarkan ekstensi),
      // coba ambil HTML dan parsing meta og:image untuk menemukan image sebenarnya.
      if (!imageUrl.endsWith(".jpg") &&
          !imageUrl.endsWith(".png") &&
          !imageUrl.endsWith(".jpeg") &&
          !imageUrl.endsWith(".gif") &&
          !imageUrl.endsWith(".webp")) {
        // Ambil konten halaman
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          // Parse HTML untuk mencari <meta property="og:image" content="...">
          final document = html_parser.parse(response.body);
          final metaImage = document
              .querySelector('meta[property="og:image"]')
              ?.attributes['content'];
          if (metaImage != null && metaImage.isNotEmpty) {
            // Gunakan og:image jika ditemukan
            finalImageUrl = metaImage;
          }
        }
      }

      // Download gambar dari finalImageUrl
      final imgResponse = await http.get(Uri.parse(finalImageUrl));
      if (imgResponse.statusCode != 200) {
        // Kalau gagal download, lempar exception
        throw Exception("Gagal mengunduh gambar (status ${imgResponse.statusCode})");
      }

      // Ambil bytes gambar
      Uint8List imageBytes = imgResponse.bodyBytes;

      // Buat nama file di storage (timestamp untuk unik)
      String fileName =
          "images/${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Referensi folder/file di Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child(fileName);

      // Upload bytes ke Firebase Storage. Set metadata contentType sebagai image/jpeg
      // (Catatan: idealnya ambil contentType dari response.header 'content-type')
      await storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Ambil URL download dan kembalikan
      return await storageRef.getDownloadURL();
    } catch (e) {
      // Jika error, cetak log dan kembalikan placeholder agar UI tetap tampil
      print("Upload gagal: $e");
      return 'https://via.placeholder.com/150';
    }
  }
}
