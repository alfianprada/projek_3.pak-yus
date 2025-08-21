import 'package:flutter/material.dart'; // UI framework Flutter
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk membaca data realtime dari Firestore
import 'package:flutter_samples/ui/components/vcard.dart'; // Komponen kartu vertikal (custom)
import 'package:flutter_samples/ui/components/hcard.dart'; // Komponen kartu horizontal (custom)
import 'package:flutter_samples/ui/models/courses.dart'; // Model data CourseModel (fromMap, fields, dll)
import 'package:flutter_samples/ui/theme.dart'; // Tema / konstanta warna aplikasi

/// HomeTabView
/// - Menampilkan daftar course dalam dua bagian:
///   1) Carousel horizontal (VCard) menampilkan semua course (urut terbaru → lama)
///   2) Section "Recent" menampilkan 4 course terbaru dalam grid responsif (HCard)
/// - Menggunakan StreamBuilder untuk membaca koleksi `courses` secara realtime dari Firestore.
class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  Widget build(BuildContext context) {
    // Ambil ukuran safe-area & lebar layar untuk tata letak responsif
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SingleChildScrollView agar konten bisa discroll bila overflow (layar kecil)
        child: SingleChildScrollView(
          // padding top ditambah 60 untuk memberi jarak dari header/menu aplikasi
          padding: EdgeInsets.only(top: topPadding + 60, bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul halaman
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Courses",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
              ),
              const SizedBox(height: 10),

              // =========================
              // Bagian: Courses horizontal
              // =========================
              SizedBox(
                height: 300, // tinggi tetap agar VCard tidak terpotong
                child: StreamBuilder<QuerySnapshot>(
                  // Stream realtime dari koleksi 'courses' di Firestore
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .orderBy('createdAt', descending: true) // urutkan terbaru dahulu
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Tampilkan loading saat menunggu data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Jika tidak ada data atau koleksi kosong -> tampilkan pesan
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No courses available."),
                      );
                    }

                    // Ambil daftar dokumen course
                    final courses = snapshot.data!.docs;

                    // ListView horizontal, setiap item menggunakan VCard (custom widget)
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        // Konversi dokumen Firestore ke Map lalu ke CourseModel
                        final data = courses[index].data() as Map<String, dynamic>;
                        return SizedBox(
                          // Lebar adaptif: pada layar sangat lebar gunakan 250, else 200
                          width: screenWidth > 992 ? 250 : 200,
                          child: VCard(
                            course: CourseModel.fromMap(
                              courses[index].id,
                              data,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // Bagian: Recent
              // =========================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
              ),
              const SizedBox(height: 10),

              // StreamBuilder kedua hanya mengambil 4 course terbaru
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .orderBy('createdAt', descending: true)
                    .limit(4) // batasi ke 4 item terbaru untuk section Recent
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Jika kosong -> tampilkan pesan
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No recent courses."),
                    );
                  }

                  final recentCourses = snapshot.data!.docs;

                  // Wrap memungkinkan layout responsif: kartu akan membungkus otomatis ke baris berikutnya
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: recentCourses.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        // Hitung lebar kartu: jika layar besar buat 2 kolom, jika kecil gunakan full width
                        final cardWidth = screenWidth > 992
                            ? (screenWidth - 30) / 2
                            : screenWidth - 20;

                        return SizedBox(
                          width: cardWidth,
                          child: HCard(
                            section: CourseModel.fromMap(doc.id, data),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
