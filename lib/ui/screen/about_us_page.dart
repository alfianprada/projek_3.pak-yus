import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/assets.dart';

/// Halaman "About Us" untuk menampilkan informasi tentang aplikasi / tim.
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controller animasi
  late Animation<Offset> _offsetAnimation; // Animasi pergeseran (slide)
  late Animation<double> _fadeAnimation; // Animasi fade in/out (opacity)

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller animasi dengan durasi 900ms
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this, // vsync = sinkronisasi animasi dengan layar
    );

    // Animasi untuk geser dari bawah (Offset(0,0.3)) ke posisi normal (Offset.zero)
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Animasi untuk fade dari 0 (transparan) ke 1 (penuh)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Jalankan animasi begitu halaman dimuat
    _controller.forward();
  }

  @override
  void dispose() {
    // Hapus controller animasi untuk menghindari memory leak
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // ambil ukuran layar

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // kembali ke halaman sebelumnya
        ),
      ),
      body: Container(
        width: double.infinity,
        // Background berupa gradient ungu → pink
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo aplikasi (diambil dari assets.dart)
                Image.asset(topi, width: 120, height: 120),
                const SizedBox(height: 20),

                // Judul utama
                const Text(
                  "Unleash Your Learning Power",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Subjudul singkat
                const Text(
                  "Smart. Interactive. Fun.\nAll-in-one course management for students and teachers alike.",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Deskripsi tentang aplikasi / tim
                const Text(
                  "CourseMaster was born from the idea that managing courses "
                  "should be simple, engaging, and efficient. Developed by Team XII RPL 1, "
                  "our mission is to empower both teachers and students "
                  "through intuitive and interactive tools.",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Fitur utama aplikasi (tampil dengan animasi Fade + Slide)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _offsetAnimation,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _featureCard(screenWidth, topic_1, "Organize Courses",
                            "Plan and manage all your courses in one place."),
                        _featureCard(screenWidth, topic_2, "Track Students",
                            "Monitor progress, attendance, and performance easily."),
                        _featureCard(screenWidth, topic_3, "Interactive Lessons",
                            "Engage students with interactive and fun learning."),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Footer (informasi pembuat)
                const Text(
                  "Developed with ❤️ by Team XII RPL 1\nEmpowering Education Together",
                  style: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Call To Action (CTA)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Text(
                    "Join us today and elevate your learning experience!",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget kecil untuk menampilkan fitur (dengan gambar, judul, dan deskripsi)
  Widget _featureCard(
      double screenWidth, String imagePath, String title, String description) {
    // Lebar card disesuaikan dengan layar (responsive)
    double cardWidth = screenWidth / 2.3;
    if (screenWidth < 350) cardWidth = screenWidth / 1.5;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon / gambar fitur
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(height: 6),

          // Judul fitur
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Deskripsi fitur
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
