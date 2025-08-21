import 'package:flutter/material.dart';               // Flutter UI toolkit (widgets, Material design)
import 'package:firebase_core/firebase_core.dart';    // Inisialisasi Firebase (firebase_core)
import 'package:firebase_auth/firebase_auth.dart';    // Firebase Authentication (login/logout + stream auth)
import 'firebase_options.dart';                       // Opsi konfigurasi Firebase yang di-generate (see notes)
import 'ui/home.dart';                                // File lokal: RiveAppHome (halaman utama aplikasi)
import 'ui/screen/login.dart';                        // File lokal: LoginPage (halaman login)

/*
  main(): titik masuk aplikasi Flutter.
  - WidgetsFlutterBinding.ensureInitialized() diperlukan jika kita memanggil native code
    (atau plugin, seperti Firebase) sebelum runApp().
  - Firebase.initializeApp(...) menginisialisasi Firebase untuk platform saat ini.
  - runApp() memulai widget tree dengan root MyApp.
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding Flutter siap sebelum memanggil plugin async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Konfigurasi Firebase per-platform (android/ios/web)
  );
  runApp(const MyApp()); // Jalankan aplikasi
}

/*
  MyApp: widget root dari aplikasi.
  - MaterialApp menyediakan tema dan routing dasar.
  - home: kita set ke AuthGate yang bertugas memilih layar (home atau login) berdasarkan auth state.
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Samples',            // Judul aplikasi (digunakan OS / task switcher)
      theme: ThemeData(
        primarySwatch: Colors.blue,        // Skema warna utama aplikasi (Material)
      ),
      home: AuthGate(),                     // Widget yang mengatur akses berdasarkan status authentication
    );
  }
}

/*
  AuthGate: widget penentu apakah user sudah login atau belum.
  - Menggunakan StreamBuilder<User?> pada FirebaseAuth.instance.authStateChanges()
    untuk "mendengarkan" perubahan status autentikasi secara realtime.
  - Jika connectionState active dan user != null => user sudah login => tampilkan RiveAppHome.
  - Jika user == null => tampilkan LoginPage.
  - Selama belum aktif (mis. menunggu nilai pertama) tampilkan loading indicator.
*/
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Stream yang memancarkan User? setiap kali status berubah
      builder: (context, snapshot) {
        // Pastikan stream sudah aktif (sudah menerima nilai/connected)
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data; // Bisa null (tidak ada user) atau User (sudah login)
          if (user != null) {
            // ❌ jangan pakai const supaya widget dapat direbuild saat user logout/login kembali
            // Const menyebabkan widget tidak direbuild walau parent rebuild — bisa membuat UI tidak update.
            return RiveAppHome();
          } else {
            // User belum login
            return const LoginPage();
          }
        }

        // Jika belum ready (mis. ConnectionState.waiting), tampilkan loading
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
