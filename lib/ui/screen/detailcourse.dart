import 'dart:math'; // untuk generate warna random
import 'package:flutter/material.dart'; // UI utama Flutter
import 'package:cloud_firestore/cloud_firestore.dart'; // akses Firestore
import 'package:url_launcher/url_launcher.dart'; // buka link video di browser/app eksternal
import 'package:firebase_auth/firebase_auth.dart'; // autentikasi pengguna
import '../models/courses.dart'; // model data course
import '../theme.dart'; // tema aplikasi (warna, background, dll)
import '../screen/editcourse.dart'; // halaman edit course

// Halaman detail course, menerima 1 course dari CourseModel
class CourseDetailPage extends StatelessWidget {
  final CourseModel course;

  const CourseDetailPage({super.key, required this.course});

  /// Fungsi untuk generate warna random (digunakan pada card konten)
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // nilai merah random (0-255)
      random.nextInt(256), // nilai hijau random (0-255)
      random.nextInt(256), // nilai biru random (0-255)
    );
  }

  /// Fungsi untuk menghapus course di Firestore
  Future<void> _deleteCourse(BuildContext context) async {
    // tampilkan dialog konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // batal hapus
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // konfirmasi hapus
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // jika user pilih "Delete"
    if (confirm == true) {
      // hapus data course di Firestore berdasarkan id
      await FirebaseFirestore.instance.collection('courses').doc(course.id).delete();
      if (context.mounted) {
        Navigator.pop(context); // tutup halaman detail
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted')), // notif berhasil
        );
      }
    }
  }

  /// Fungsi untuk membuka link video (jika ada)
  Future<void> _launchVideo(BuildContext context) async {
    if (course.videoUrl.isEmpty) return; // kalau kosong, abaikan
    final url = Uri.parse(course.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // buka pakai browser/app eksternal
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch video')), // notif error
        );
      }
    }
  }

  /// Fungsi untuk memformat tanggal supaya lebih rapi
  String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final randomColor = getRandomColor(); // warna random untuk card konten
    final currentUserId = FirebaseAuth.instance.currentUser!.uid; // ambil id user aktif
    final isCreator = course.creatorId == currentUserId; // cek apakah user adalah pembuat course

    return Container(
      color: RiveAppTheme.background2, // warna background luar
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            backgroundColor: RiveAppTheme.background,
            appBar: AppBar(
              title: Text(
                course.title, // judul course
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: RiveAppTheme.background,
              elevation: 0,
            ),

            // isi halaman bisa discroll
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ✅ Gambar dengan error handling
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Image.network(
                        course.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child; // gambar sudah ter-load
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text(
                              "Image Link Not Supported. Try Another Image.",
                              style: TextStyle(color: Colors.black54, fontFamily: "Inter"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// ✅ Video link (klik untuk buka)
                    if (course.videoUrl.isNotEmpty)
                      InkWell(
                        onTap: () => _launchVideo(context),
                        child: Text(
                          course.videoUrl,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),

                    /// ✅ Tanggal dibuat
                    Text(
                      getFormattedDate(course.createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontFamily: "Inter",
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// ✅ Konten course dengan card warna random
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: randomColor,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          course.content.isNotEmpty
                              ? course.content
                              : "No content available.", // jika kosong tampilkan pesan
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// ✅ Tombol Edit & Delete (hanya muncul jika creator)
                    if (isCreator)
                      Row(
                        children: [
                          // tombol edit
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                // pindah ke halaman EditCoursePage
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCoursePage(course: course),
                                  ),
                                );
                                // jika berhasil update, tampilkan snackbar
                                if (result == true && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Course updated!')),
                                  );
                                }
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // tombol delete
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[500],
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _deleteCourse(context),
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
