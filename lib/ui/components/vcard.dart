import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

/// Widget kartu (card) untuk menampilkan informasi singkat sebuah `CourseModel`.
/// - Menampilkan judul course, deskripsi singkat, dan waktu dibuat (relative time).
/// - Warna background diacak setiap kali dibuat (random).
/// - Jika diklik, akan membuka halaman detail (`CourseDetailPage`).
class VCard extends StatefulWidget {
  const VCard({Key? key, required this.course}) : super(key: key);

  /// Data course yang ditampilkan di kartu ini
  final CourseModel course;

  @override
  State<VCard> createState() => _VCardState();
}

class _VCardState extends State<VCard> {
  /// Warna kartu akan diacak menggunakan [getRandomColor()]
  late Color cardColor;

  @override
  void initState() {
    super.initState();
    // Atur warna kartu secara acak saat pertama kali dibuat
    cardColor = getRandomColor();
  }

  /// Fungsi untuk menghasilkan warna acak (ARGB dengan nilai RGB random)
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // alpha 100% (full opacity)
      random.nextInt(256), // merah
      random.nextInt(256), // hijau
      random.nextInt(256), // biru
    );
  }

  /// Mengubah tanggal `createdAt` menjadi format "relative time"
  /// Contoh: "2 minutes ago", "3 days ago", "Just now"
  String formatDate(DateTime? date) {
    if (date == null) return '';

    final Duration diff = DateTime.now().difference(date);

    // Fungsi bantu untuk menambahkan "s" saat plural
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
      // Saat kartu ditekan → navigasi ke halaman detail course
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: widget.course),
          ),
        );
      },
      child: Container(
        // Atur ukuran maksimal kartu
        constraints: const BoxConstraints(maxWidth: 260, maxHeight: 310),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          // Background gradient dari warna acak
          gradient: LinearGradient(
            colors: [cardColor, cardColor.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Efek bayangan supaya tampak mengangkat (elevasi)
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: cardColor.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          // Membuat kartu dengan sudut melengkung (rounded corners)
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul course
            Text(
              widget.course.title,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Konten course (dibatasi 3 baris, dengan ellipsis jika terlalu panjang)
            Text(
              widget.course.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            // Tanggal dibuat → ditampilkan dalam bentuk "relative time"
            Text(
              formatDate(widget.course.createdAt),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
