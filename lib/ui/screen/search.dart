import 'dart:math'; // ✅ Digunakan untuk menghasilkan warna random dengan Random()
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Untuk mengambil data courses dari Firestore
import 'package:flutter/material.dart'; // ✅ UI Flutter
import 'package:flutter_samples/ui/models/courses.dart'; // ✅ Model data Course
import 'package:flutter_samples/ui/screen/detailcourse.dart'; // ✅ Halaman detail course
import 'package:flutter_samples/ui/theme.dart'; // ✅ Tema aplikasi (warna, background, dll)

/// Halaman SearchPage untuk mencari kursus yang tersimpan di Firestore
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = ''; // ✅ Menyimpan kata kunci pencarian
  final Random random = Random(); // ✅ Untuk membuat warna random tiap card

  /// Fungsi untuk menghasilkan warna acak
  Color getRandomColor() {
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2, // ✅ Warna background dari tema
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background, // ✅ Warna utama background card
            borderRadius: BorderRadius.circular(30), // ✅ Membuat sudut rounded
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                /// Judul Halaman
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔍 Search box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search courses...", // Placeholder
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery =
                                  value.toLowerCase(); // ✅ Simpan query pencarian
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// 📌 List Course dari Firestore
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('courses') // Ambil data dari koleksi "courses"
                        .orderBy('createdAt', descending: true) // Urutkan terbaru
                        .snapshots(), // Stream real-time
                    builder: (context, snapshot) {
                      // Jika masih loading
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Jika tidak ada data sama sekali
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No courses found.",
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                        );
                      }

                      // 🔄 Konversi dokumen ke model Course
                      final courses = snapshot.data!.docs
                          .map((doc) => CourseModel.fromMap(
                                doc.id,
                                doc.data() as Map<String, dynamic>,
                              ))
                          // ✅ Filter data sesuai searchQuery (judul atau isi)
                          .where((course) =>
                              course.title
                                  .toLowerCase()
                                  .contains(searchQuery) ||
                              course.content
                                  .toLowerCase()
                                  .contains(searchQuery))
                          .toList();

                      // Jika hasil pencarian kosong
                      if (courses.isEmpty) {
                        return const Center(
                          child: Text(
                            "No matching courses.",
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                        );
                      }

                      // ✅ Tampilkan list course
                      return ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return GestureDetector(
                            onTap: () {
                              // ✅ Buka halaman detail course saat di-tap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourseDetailPage(course: course),
                                ),
                              );
                            },
                            child: _buildBabTile(
                              course.title, // Judul course
                              course.content, // Deskripsi course
                              getRandomColor(), // Warna random tiap card
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ Widget custom untuk menampilkan card Course (judul + deskripsi)
  Widget _buildBabTile(String bab, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          /// Bagian Judul Course
          Row(
            children: [
              Text(
                bab,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 2,
                height: 50,
                color: Colors.white54, // Garis pemisah
              ),
              const SizedBox(width: 14),
            ],
          ),

          /// Bagian Deskripsi (singkat)
          Expanded(
            child: Text(
              desc,
              maxLines: 1, // Batas 1 baris
              overflow: TextOverflow.ellipsis, // Tambahkan "..." jika panjang
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
