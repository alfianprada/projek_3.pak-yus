// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/screen/login.dart';

// Widget utama untuk halaman awal aplikasi (Get Started)
class GetStart extends StatefulWidget {
  const GetStart({super.key});

  @override
  State<GetStart> createState() => _GetStartState();
}

// State untuk GetStart, mengelola UI halaman awal
class _GetStartState extends State<GetStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body utama menggunakan Container sebagai wrapper
      body: Container(
        // Mengatur lebar container agar memenuhi layar
        width: double.infinity,
        // Menambahkan gambar latar belakang
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/samples/images/bgawal.png'), // Gambar latar belakang
            fit: BoxFit.cover, // Gambar menyesuaikan lebar layar
          ),
        ),
        // Menempatkan konten di tengah secara vertikal dan horizontal
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Menyusun anak secara vertikal di tengah
            children: [
              // Logo aplikasi
              Container(
                width: 150,
                height: 150,
                child: Image.asset('assets/samples/images/topi.png'), // Gambar logo topi
              ),
              const SizedBox(height: 20), // Jarak antar elemen
              // Teks judul aplikasi
              const Text(
                'SkillUp!',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: "Poppins", // Font kustom
                  fontWeight: FontWeight.bold, // Tebal
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Jarak antar elemen
              // Teks deskripsi aplikasi
              const Text(
                'empower your learning journey',
                style: TextStyle(
                  fontFamily: "Poppins", // Font kustom
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30), // Jarak antar elemen
              // Tombol untuk memulai aplikasi
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman RiveAppHome saat tombol diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  // Dekorasi tombol dengan gradien
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)], // Warna gradien biru ke ungu
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30), // Sudut membulat
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding tombol
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter", // Font kustom untuk tombol
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}