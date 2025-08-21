import 'package:cloud_firestore/cloud_firestore.dart';

/// Model data untuk Course (dipakai untuk membaca / menulis dokumen dari koleksi `courses`)
/// - Gunakan CourseModel.fromMap(...) untuk mengonversi data Firestore -> object
/// - Gunakan CourseModel.toMap() untuk mengonversi object -> Map agar bisa disimpan ke Firestore
class CourseModel {
  // Unique identifier dokumen (Firestore doc id)
  final String id;

  // Judul course (mis. "Flutter for Beginners")
  final String title;

  // URL gambar ilustrasi. Jika tidak valid, fallback ke placeholder.
  final String imageUrl;

  // URL video (mis. embed/YouTube link). Boleh kosong.
  final String videoUrl;

  // Konten/penjelasan course (string panjang)
  final String content;

  // ID user yang membuat course. Penting untuk otorisasi (edit/delete hanya creator).
  final String creatorId; // <-- wajib diisi saat membuat/memap

  // Waktu pembuatan (nullable karena mungkin belum terset dan Firestore menggunakan serverTimestamp)
  final DateTime? createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.content,
    required this.creatorId,
    this.createdAt,
  });

  /// Factory constructor: buat CourseModel dari Map (hasil `.data()` dari Firestore).
  /// - `id` : doc.id dari Firestore
  /// - `data` : Map<String, dynamic> dari snapshot.data()
  factory CourseModel.fromMap(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      // ambil title, fallback string kosong jika tidak ada
      title: data['title'] ?? '',
      // Pastikan imageUrl valid (awalannya http...), kalau tidak gunakan placeholder
      imageUrl: (data['imageUrl'] != null && data['imageUrl'].toString().startsWith('http'))
          ? data['imageUrl']
          : 'https://via.placeholder.com/150',
      videoUrl: data['videoUrl'] ?? '',
      content: data['content'] ?? '',
      // Ambil creatorId dari DB. Jika tidak ada, menjadi string kosong (pertimbangkan validasi)
      creatorId: data['creatorId'] ?? '',
      // Firestore menyimpan timestamp sebagai Timestamp, konversi ke DateTime
      createdAt: (data['createdAt'] != null && data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Konversi CourseModel -> Map untuk disimpan ke Firestore.
  /// - Jika createdAt ada, konversi ke Timestamp.
  /// - Jika createdAt null, gunakan FieldValue.serverTimestamp() supaya server men-set waktu.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'content': content,
      'creatorId': creatorId,
      // Jika ada createdAt lokal gunakan Timestamp.fromDate,
      // kalau tidak, berikan serverTimestamp agar Firestore mengisi nilainya.
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
