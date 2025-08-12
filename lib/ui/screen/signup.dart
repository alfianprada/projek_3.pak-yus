// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/home.dart';
// Mengimpor widget RiveAppHome dari file home.dart

// Widget utama untuk halaman awal aplikasi (Get Started)
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// State untuk SignUpPage, mengelola UI halaman awal
class _SignUpPageState extends State<SignUpPage> {
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
            image: AssetImage(
              'assets/samples/images/bgawal.png',
            ), // Gambar latar belakang
            fit: BoxFit.cover, // Gambar menyesuaikan lebar layar
          ),
        ),
        // Menempatkan konten di tengah secara vertikal dan horizontal
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center, // Menyusun anak secara vertikal di tengah
            children: [
              // Logo aplikasi
              Container(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/samples/images/topi.png',
                ), // Gambar logo topi
              ),
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
              const SizedBox(height: 20), // Jarak antar elemen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23, // Tinggi lebih besar di sini
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Gmail',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Tombol untuk memulai aplikasi
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman RiveAppHome saat tombol diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RiveAppHome()),
                  );
                },
                child: Container(
                  // Dekorasi tombol dengan gradien
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4B5EAA),
                        Color(0xFF8A4AF3),
                      ], // Warna gradien biru ke ungu
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30), // Sudut membulat
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ), // Padding tombol
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
