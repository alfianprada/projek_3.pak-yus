// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor komponen VCard untuk kartu kursus vertikal
import 'package:flutter_samples/ui/components/vcard.dart';
// Mengimpor komponen HCard untuk kartu kursus horizontal
import 'package:flutter_samples/ui/components/hcard.dart';
// Mengimpor model data untuk kursus
import 'package:flutter_samples/ui/models/courses.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';

// Widget utama untuk tab beranda aplikasi
class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

// State untuk HomeTabView, mengelola daftar kursus
class _HomeTabViewState extends State<HomeTabView> {
  // Daftar kursus untuk bagian "Courses"
  final List<CourseModel> _courses = CourseModel.courses;
  // Daftar seksi kursus untuk bagian "Recent"
  final List<CourseModel> _courseSections = CourseModel.courseSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang transparan untuk integrasi dengan desain luar
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.hardEdge, // Memotong konten di luar batas
        decoration: BoxDecoration(
          color: RiveAppTheme.background, // Warna latar belakang tema
          borderRadius: BorderRadius.circular(30), // Sudut membulat
        ),
        child: SingleChildScrollView(
          // Padding menyesuaikan safe area dengan tambahan jarak atas
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Konten rata kiri
            children: [
              // Judul bagian "Courses"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Courses",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
              ),
              // Daftar kursus horizontal
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _courses
                      .map(
                        (course) => Padding(
                          key: course.id, // Key unik untuk performa
                          padding: const EdgeInsets.all(10),
                          child: VCard(course: course), // Kartu kursus vertikal
                        ),
                      )
                      .toList(),
                ),
              ),
              // Judul bagian "Recent"
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
              ),
              // Daftar seksi kursus dalam tata letak wrap
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  children: List.generate(
                    _courseSections.length,
                    (index) => Container(
                      key: _courseSections[index].id, // Key unik untuk performa
                      // Lebar responsif: 2 kolom untuk layar lebar, 1 kolom untuk layar kecil
                      width: MediaQuery.of(context).size.width > 992
                          ? ((MediaQuery.of(context).size.width - 20) / 2)
                          : MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: HCard(section: _courseSections[index]), // Kartu kursus horizontal
                    ),
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