// Mengimpor package material dari Flutter untuk menggunakan widget Material Design
import 'package:flutter/material.dart';
// Mengimpor file getstart.dart yang berisi widget GetStart
import 'package:flutter_samples/ui/getstart.dart';


// Fungsi main adalah titik masuk aplikasi Flutter
void main() {
  // Menjalankan aplikasi dengan widget MyApp sebagai root
  runApp(const MyApp());
}

// MyApp adalah widget Stateless yang menjadi root aplikasi
class MyApp extends StatelessWidget {
  // Konstruktor dengan parameter key opsional
  const MyApp({super.key});

  // Method build mendefinisikan UI aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menonaktifkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Judul aplikasi yang digunakan oleh sistem operasi
      title: 'Flutter Project 2',
      // Mendefinisikan tema aplikasi dengan warna utama biru
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Menetapkan GetStart sebagai halaman awal aplikasi
      home: GetStart(),
    );
  }
}