import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/courses.dart';
import 'detailcourse.dart';

/// Halaman untuk menampilkan daftar semua course
/// yang disimpan di koleksi `courses` di Firebase Firestore.
class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar sebagai judul halaman
      appBar: AppBar(title: const Text('Courses')),

      /// Body menggunakan StreamBuilder untuk mengambil data real-time
      body: StreamBuilder<QuerySnapshot>(
        /// Stream dari koleksi `courses`, diurutkan berdasarkan `createdAt` terbaru
        stream: FirebaseFirestore.instance
            .collection('courses')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        /// builder akan dipanggil setiap kali ada perubahan data pada Firestore
        builder: (context, snapshot) {
          /// Jika data belum ada, tampilkan loading indicator
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          /// Ambil semua dokumen dari snapshot
          final docs = snapshot.data!.docs;

          /// Gunakan ListView.builder agar efisien ketika data banyak
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              /// Ambil data dokumen sebagai Map
              final data = docs[index].data() as Map<String, dynamic>;

              /// Konversi ke dalam model CourseModel (agar lebih terstruktur)
              final course = CourseModel.fromMap(docs[index].id, data);

              /// Tampilkan setiap course dalam bentuk Card + ListTile
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  /// Gambar course (jika link tidak valid, tampilkan icon default)
                  leading: Image.network(
                    course.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 60),
                  ),

                  /// Judul course
                  title: Text(course.title),

                  /// Subtitle berisi link video (jika ada) + isi konten
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Tampilkan link video jika ada
                      if (course.videoUrl.isNotEmpty)
                        Text(
                          'Video: ${course.videoUrl}',
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),

                      /// Tampilkan isi konten jika ada (dibatasi max 2 baris)
                      if (course.content.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            course.content,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            maxLines: 2, // supaya tidak terlalu panjang
                            overflow: TextOverflow.ellipsis, // potong dengan "..."
                          ),
                        ),
                    ],
                  ),

                  /// Ketika card di-tap, buka halaman detail
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(course: course),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
