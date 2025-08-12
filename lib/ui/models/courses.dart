// Mengimpor package material dari Flutter untuk widget Material Design (digunakan untuk UniqueKey dan Color)
import 'package:flutter/material.dart';
// Mengimpor aset aplikasi, seperti path gambar
import 'package:flutter_samples/ui/assets.dart' as app_assets;

// Kelas model untuk data kursus
class CourseModel {
  // Konstruktor dengan parameter opsional untuk properti kursus
  CourseModel({
    this.id,
    this.title = "", // Judul kursus, default kosong
    this.subtitle = "", // Subjudul kursus, default kosong
    this.caption = "", // Keterangan kursus, default kosong
    this.color = Colors.white, // Warna latar belakang kartu, default putih
    this.image = "", // Path gambar untuk kursus, default kosong
    this.link = "",
    this.images = "",
  });

  // ID unik untuk setiap kursus, digunakan untuk performa dan manajemen widget
  UniqueKey? id = UniqueKey();
  // Properti kursus
  String title, caption, image, link, images;
  String? subtitle; // Subjudul opsional
  Color color;

  // Daftar statis untuk kursus utama (ditampilkan di bagian "Courses")
  static List<CourseModel> courses = [
    CourseModel(
      title: "Animations in SwiftUI",
      subtitle: "Build and animate an iOS app from scratch",
      caption: "20 sections - 3 hours",
      link: "https://www.youtube.com/watch?",
      color: const Color(0xFF7850F0), // Warna ungu
      image: app_assets.topic_3, // Gambar topik 1
      images: app_assets.topic_1,
    ), // Gambar topik 1
    CourseModel(
      title: "Build Quick Apps with SwiftUI",
      subtitle:
          "Apply your Swift and SwiftUI knowledge by building real, quick and various applications from scratch",
      caption: "47 sections - 11 hours",
      link: "https://www.youtube.com/watch?",
      color: const Color(0xFF6792FF), // Warna biru muda
      image: app_assets.topic_3,
      images: app_assets.topic_1,
    ), // Gambar topik 2
    CourseModel(
      title: "Build a SwiftUI app for iOS 15",
      subtitle:
          "Design and code a SwiftUI 3 app with custom layouts, animations and gestures using Xcode 13, SF Symbols 3, Canvas, Concurrency, Searchable and a whole lot more",
      caption: "21 sections - 4 hours",
      link: "https://www.youtube.com/watch?",
      color: const Color(0xFF005FE7), // Warna biru tua
      image: app_assets.topic_3,
      images: app_assets.topic_2,
    ),
    CourseModel(
      title: "State Machine",
      subtitle: "Build and animate an iOS app from scratch",
      caption: "12 sections - 1 hours",
      link: "https://www.youtube.com/watch?",
      color: const Color(0xFF7850F0), // Warna ungu
      image: app_assets.topic_3,
      images: app_assets.topic_2,
    ), // Gambar topik 1// Gambar topik 1
    CourseModel(
      title: "NIkko setiawan",
      subtitle: "Build and animate an iOS app from scratch",
      caption: "12 sections - 1 hours",
      link: "https://www.youtube.com/watch?",
      color: const Color(0xFF7850F0), // Warna ungu
      image: app_assets.topic_3,
      images: app_assets.topic_2,
    ), // Gambar topik 1// Gambar topik 1
  ];

  // Daftar statis untuk seksi kursus (ditampilkan di bagian "Recent")
  static List<CourseModel> courseSections = [
    CourseModel(
      title: "State Machine",
      caption: "Watch video - 15 mins",
      color: const Color(0xFF9CC5FF), // Warna biru cerah
      image: app_assets.topic_2,
    ), // Gambar topik 2
    CourseModel(
      title: "Animated Menu",
      caption: "Watch video - 10 mins",
      color: const Color(0xFF6E6AE8), // Warna ungu tua
      image: app_assets.topic_1,
    ), // Gambar topik 1
    CourseModel(
      title: "Tab Bar",
      caption: "Watch video - 8 mins",
      color: const Color(0xFF005FE7), // Warna biru tua
      image: app_assets.topic_2,
    ), // Gambar topik 2
    CourseModel(
      title: "Button",
      caption: "Watch video - 9 mins",
      color: const Color(0xFFBBA6FF), // Warna ungu muda
      image: app_assets.topic_1,
    ), // Gambar topik 1
  ];
}
