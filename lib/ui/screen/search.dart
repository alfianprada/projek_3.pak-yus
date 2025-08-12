// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';

// Widget untuk halaman pencarian aplikasi
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
                  'Search',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins", // Font kustom
                  ),
                ),
                const SizedBox(height: 20), // Jarak antar elemen
                // Kolom pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20), // Padding dalam kolom pencarian
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white, // Latar belakang putih
                    borderRadius: BorderRadius.circular(25), // Sudut membulat
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12, // Bayangan halus
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey), // Ikon pencarian
                      SizedBox(width: 10), // Jarak antar ikon dan teks
                      Text(
                        "Searching...", // Placeholder teks pencarian
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Jarak antar elemen
                // Daftar item pencarian
                Expanded(
                  child: ListView(
                    children: [
                      // Item daftar untuk setiap bab
                      _buildBabTile(
                        "Chapter 1",
                        "Introduction to Software",
                        "assets/samples/images/topic_2.png", // Ikon bab
                        const Color(0xFF9CC5FF), // Warna latar belakang
                      ),
                      _buildBabTile(
                        "Chapter 2",
                        "Basic Logic and Algorithms",
                        "assets/samples/images/topic_1.png",
                        const Color(0xFF6E6AE8),
                      ),
                      _buildBabTile(
                        "Chapter 3",
                        "Basic Programming Language",
                        "assets/samples/images/topic_2.png",
                        const Color(0xFF005FE7),
                      ),
                      _buildBabTile(
                        "Chapter 4",
                        "Basic Programming",
                        "assets/samples/images/topic_1.png",
                        const Color(0xFFBBA6FF),
                      ),
                      _buildBabTile(
                        "Chapter 7",
                        "UI Design with Figma",
                        "assets/samples/images/topic_2.png",
                        const Color(0xFF58CAFF),
                      ),
                      _buildBabTile(
                        "Chapter 8",
                        "Web Application Development",
                        "assets/samples/images/topic_1.png",
                        const Color(0xFF8D75DC),
                      ),
                      _buildBabTile(
                        "Chapter 9",
                        "Database",
                        "assets/samples/images/topic_2.png",
                        const Color.fromARGB(255, 88, 105, 255),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun tile bab dengan desain kustom
  static Widget _buildBabTile(String bab, String desc, String iconPath, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Jarak antar tile
      decoration: BoxDecoration(
        color: color, // Warna latar belakang tile
        borderRadius: BorderRadius.circular(30), // Sudut membulat
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Bayangan tile
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), // Padding dalam tile
      child: Row(
        children: [
          Row(
            children: [
              // Teks nomor bab
              Text(
                bab,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14), // Jarak antar elemen
              // Garis pemisah vertikal
              Container(
                width: 2,
                height: 50,
                color: Colors.white54,
              ),
              const SizedBox(width: 14), // Jarak antar elemen
            ],
          ),
          // Deskripsi bab
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          // Ikon bab
          Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              iconPath, // Path ikon bab
              width: 45,
              height: 45,
            ),
          ),
        ],
      ),
    );
  }
}