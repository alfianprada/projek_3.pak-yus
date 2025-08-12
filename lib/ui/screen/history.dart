// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';

// Widget untuk halaman riwayat aplikasi
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Latar belakang menggunakan warna sekunder dari tema (biru tua)
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
          // Kontainer utama dengan latar belakang tema dan sudut membulat
          decoration: BoxDecoration(
            color: RiveAppTheme.background, // Warna latar belakang utama (biru terang)
            borderRadius: BorderRadius.circular(30), // Sudut membulat
          ),
          clipBehavior: Clip.hardEdge, // Memotong konten yang melebihi batas border
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding dalam
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
              children: [
                const SizedBox(height: 50), // Jarak atas
                // Judul halaman
                const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins", // Font kustom
                    fontWeight: FontWeight.bold, // Tebal
                  ),
                ),
                const SizedBox(height: 300), // Jarak besar sebelum pesan
                // Pesan ketika tidak ada riwayat
                Center(
                  child: Text(
                    'No history',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Inter", // Font kustom berbeda untuk pesan
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}