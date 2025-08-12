// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';

// Widget untuk halaman akun aplikasi
class AcountPage extends StatelessWidget {
  const AcountPage({super.key});

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
                  'Acount',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins", // Font kustom
                    fontWeight: FontWeight.bold, // Tebal
                  ),
                ),
                const SizedBox(height: 20), // Jarak antar elemen
                // Ikon akun di tengah
                const Center(
                  child: Icon(
                    Icons.account_circle, // Ikon profil default
                    size: 100,
                    color: Colors.black,
                  ),
                ),
                // Nama atau kelas pengguna
                Center(
                  child: Text(
                    'XII RPL 1', // Menunjukkan kelas atau identitas pengguna
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: "Inter", // Font kustom berbeda
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Jarak antar elemen
                // Daftar opsi akun
                Expanded(
                  child: ListView(
                    children: [
                      // Item daftar untuk setiap opsi akun
                      _buildTile("General", Icons.settings, Color(0xFF7850F0)),
                      _buildTile("Security", Icons.security, Color(0xFF6792FF)),
                      _buildTile("Payment", Icons.payment, Color(0xFF005FE7)),
                      _buildTile("Contact Us", Icons.contact_support, Color(0xFFBBA6FF)),
                      _buildTile("Log out", Icons.logout, Color(0xFF9CC5FF)),
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

  // Fungsi untuk membangun tile opsi akun dengan desain kustom
  static Widget _buildTile(String title, IconData leadingIcon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), // Jarak antar tile
      decoration: BoxDecoration(
        color: color, // Warna latar belakang tile
        borderRadius: BorderRadius.circular(15), // Sudut membulat
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Bayangan halus
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Padding dalam tile
      child: Row(
        children: [
          // Ikon di sisi kiri
          Icon(leadingIcon, size: 26, color: Colors.white), // Ikon putih untuk kontras
          const SizedBox(width: 16), // Jarak antar ikon dan teks
          // Judul opsi
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Teks putih untuk kontras dengan warna tile
              ),
            ),
          ),
          // Ikon panah untuk indikasi aksi
          const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white70),
        ],
      ),
    );
  }
}