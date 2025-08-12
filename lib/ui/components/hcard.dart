// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor model data untuk kursus
import 'package:flutter_samples/ui/models/courses.dart';

// Widget untuk kartu kursus horizontal
class HCard extends StatelessWidget {
  const HCard({Key? key, required this.section}) : super(key: key);

  // Data seksi kursus yang ditampilkan pada kartu
  final CourseModel section;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Membatasi tinggi maksimum kartu
      constraints: const BoxConstraints(maxHeight: 110),
      // Padding dalam kartu
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      // Dekorasi kartu dengan warna dari section dan sudut membulat
      decoration: BoxDecoration(
        color: section.color, // Warna latar belakang dari CourseModel
        borderRadius: BorderRadius.circular(30), // Sudut membulat
      ),
      child: Row(
        children: [
          // Kolom teks yang mengisi ruang tersedia
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Kolom menyesuaikan konten
              crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
              children: [
                // Judul seksi kursus
                Text(
                  section.title,
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins", // Font kustom
                      color: Colors.white),
                ),
                const SizedBox(height: 8), // Jarak antar teks
                // Keterangan seksi kursus
                Text(
                  section.caption,
                  style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "Inter", // Font kustom
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // Garis pemisah vertikal
          const Padding(
            padding: EdgeInsets.all(20),
            child: VerticalDivider(thickness: 0.8, width: 0),
          ),
          // Gambar seksi kursus
          Image.asset(section.image), // Gambar dari CourseModel
        ],
      ),
    );
  }
}