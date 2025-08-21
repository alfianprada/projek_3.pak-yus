import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

/// Widget HCard (Horizontal Card)
/// -------------------------------------------
/// Widget ini menampilkan informasi singkat dari `CourseModel`
/// dalam bentuk kartu horizontal (lebih pendek & melebar).
/// Jika diklik, maka akan membuka halaman detail kursus (`CourseDetailPage`).
class HCard extends StatefulWidget {
  const HCard({Key? key, required this.section}) : super(key: key);

  /// Data course yang dikirim ke kartu ini
  final CourseModel section;

  @override
  State<HCard> createState() => _HCardState();
}

class _HCardState extends State<HCard> {
  /// Warna random untuk background kartu
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    // Tentukan warna random setiap kali kartu dibuat
    cardColor = getRandomColor();
  }

  /// Fungsi untuk menghasilkan warna acak
  /// digunakan untuk membuat kartu terlihat lebih variatif
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  /// Fungsi untuk format tanggal (createdAt)
  /// Menampilkan teks waktu relatif, contoh:
  /// "Just now", "5 minutes ago", "2 days ago"
  String formatDate(DateTime? date) {
    if (date == null) return '';

    final Duration diff = DateTime.now().difference(date);

    // Helper untuk menambahkan 's' jika lebih dari 1
    String plural(int value, String unit) =>
        "$value $unit${value == 1 ? '' : 's'} ago";

    if (diff.inSeconds < 5) {
      return "Just now";
    } else if (diff.inSeconds < 60) {
      return plural(diff.inSeconds, "second");
    } else if (diff.inMinutes < 60) {
      return plural(diff.inMinutes, "minute");
    } else if (diff.inHours < 24) {
      return plural(diff.inHours, "hour");
    } else if (diff.inDays < 7) {
      return plural(diff.inDays, "day");
    } else if (diff.inDays < 30) {
      return plural((diff.inDays / 7).floor(), "week");
    } else if (diff.inDays < 365) {
      return plural((diff.inDays / 30).floor(), "month");
    } else {
      return plural((diff.inDays / 365).floor(), "year");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Saat kartu diklik → pindah ke halaman detail course
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: widget.section),
          ),
        );
      },
      child: Container(
        // Ukuran maksimal tinggi kartu = 110px
        constraints: const BoxConstraints(maxHeight: 110),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          // Background gradient → warna random
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            // Efek bayangan agar kartu terlihat "mengambang"
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: cardColor.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Bagian teks di sebelah kiri
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Course
                  Text(
                    widget.section.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tanggal dibuat (relative time)
                  Text(
                    formatDate(widget.section.createdAt),
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
