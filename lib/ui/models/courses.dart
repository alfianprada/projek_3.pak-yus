import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String imageUrl;
  final String videoUrl;
  final String content;
  final String creatorId; // <-- tambahkan
  final DateTime? createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.content,
    required this.creatorId, // <-- wajib diisi
    this.createdAt,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      title: data['title'] ?? '',
      imageUrl: (data['imageUrl'] != null && data['imageUrl'].toString().startsWith('http'))
          ? data['imageUrl']
          : 'https://via.placeholder.com/150',
      videoUrl: data['videoUrl'] ?? '',
      content: data['content'] ?? '',
      creatorId: data['creatorId'] ?? '', // <-- ambil dari DB
      createdAt: (data['createdAt'] != null && data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'content': content,
      'creatorId': creatorId, // <-- simpan saat create
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
