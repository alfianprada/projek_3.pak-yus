// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor package physics untuk simulasi animasi berbasis fisika (spring)
import 'package:flutter/physics.dart';
import 'screen/addcourse.dart'; // Make sure this import exists
// Mengimpor package services untuk mengontrol overlay sistem (status bar)
import 'package:flutter/services.dart';
// Mengimpor halaman-halaman aplikasi
import 'package:flutter_samples/ui/screen/acount.dart';
import 'package:flutter_samples/ui/screen/addcourse.dart';
// Mengimpor package Rive untuk animasi interaktif, dengan pengecualian LinearGradient dan Image
import 'package:rive/rive.dart' hide LinearGradient, Image;
// Mengimpor library matematika untuk operasi rotasi
import 'dart:math' as math;
// Mengimpor komponen navigasi kustom
import 'package:flutter_samples/ui/navigation/custom_tab_bar.dart';
import 'package:flutter_samples/ui/navigation/home_tab_view.dart';
import 'package:flutter_samples/ui/navigation/side_menu.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';
// Mengimpor aset aplikasi (kemungkinan path file Rive atau gambar)
import 'package:flutter_samples/ui/assets.dart' as app_assets;
// Mengimpor halaman pencarian
import 'package:flutter_samples/ui/screen/search.dart';

// Fungsi untuk membungkus konten tab dengan container berlatar belakang tema
Widget commonTabScene(Widget content) {
  return Container(
    // Menggunakan warna latar belakang dari tema aplikasi
    decoration: BoxDecoration(
      color: RiveAppTheme.background,
    ),
    // Menempatkan konten di tengah
    alignment: Alignment.center,
    child: content,
  );
}

// Widget utama untuk halaman utama aplikasi dengan animasi Rive
class RiveAppHome extends StatefulWidget {
  const RiveAppHome({super.key});

  // Rute untuk navigasi ke halaman ini
  static const String route = '/course-rive';

  @override
  State<RiveAppHome> createState() => _RiveAppHomeState();
}

// State untuk RiveAppHome, mengelola animasi dan status
class _RiveAppHomeState extends State<RiveAppHome>
    with TickerProviderStateMixin {
  // Kontroler untuk animasi sidebar
  late AnimationController? _animationController;
  // Kontroler untuk animasi onboarding
  late AnimationController? _onBoardingAnimController;
  // Animasi untuk onboarding
  late Animation<double> _onBoardingAnim;
  // Animasi untuk sidebar
  late Animation<double> _sidebarAnim;

  // Variabel untuk mengontrol status tombol menu di animasi Rive
  late SMIBool _menuBtn;

  // Menentukan apakah onboarding ditampilkan (saat ini tidak aktif)
  final bool _showOnBoarding = false;
  // Widget default untuk konten tab
  Widget _tabBody = Container(color: RiveAppTheme.background);
  // Daftar halaman yang dapat ditampilkan di tab
  final List<Widget> _screens = [
    const HomeTabView(),
    commonTabScene(const SearchPage()),
    commonTabScene(const AddCoursePage()),
    commonTabScene(const AcountPage()),
  ];
  // Konfigurasi animasi spring untuk efek halus
  final springDesc = const SpringDescription(
    mass: 0.1, // Massa untuk simulasi fisika
    stiffness: 40, // Kekakuan pegas
    damping: 5, // Redaman untuk mengurangi osilasi
  );

  // Inisialisasi animasi tombol menu dari file Rive
  void _onMenuIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine",
    );
    artboard.addController(controller!);
    // Mengambil input boolean 'isOpen' dari state machine Rive
    _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
    _menuBtn.value = true; // Set default tombol menu ke terbuka
  }

  // Fungsi untuk menangani klik tombol menu
  void onMenuPress() {
    if (_menuBtn.value) {
      // Menggunakan animasi spring saat menu dibuka
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      // Membalikkan animasi saat menu ditutup
      _animationController?.reverse();
    }
    // Mengubah status tombol menu
    _menuBtn.change(!_menuBtn.value);

    // Mengubah gaya overlay sistem (status bar) berdasarkan status menu
    SystemChrome.setSystemUIOverlayStyle(
      _menuBtn.value ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi kontroler animasi sidebar
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    // Inisialisasi kontroler animasi onboarding
    _onBoardingAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      upperBound: 1,
      vsync: this,
    );

    // Mengatur animasi sidebar dengan kurva linear
    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.linear),
    );

    // Mengatur animasi onboarding dengan kurva linear
    _onBoardingAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _onBoardingAnimController!, curve: Curves.linear),
    );

    // Mengatur halaman awal sebagai tab pertama
    _tabBody = _screens.first;
  }

  @override
  void dispose() {
    // Membersihkan kontroler animasi untuk mencegah kebocoran memori
    _animationController?.dispose();
    _onBoardingAnimController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengizinkan konten meluas di bawah status bar
      extendBody: true,
      body: Stack(
        children: [
          // Latar belakang dengan warna sekunder dari tema
          Positioned(child: Container(color: RiveAppTheme.background2)),
          // Animasi sidebar dengan transformasi rotasi dan translasi
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Menambahkan perspektif 3D
                    ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180) // Rotasi Y
                    ..translate((1 - _sidebarAnim.value) * -300), // Translasi horizontal
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                child: const SideMenu(), // Widget menu samping
              ),
            ),
          ),
          // Konten utama dengan animasi skala dan rotasi
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _showOnBoarding ? _onBoardingAnim : _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - (_showOnBoarding ? _onBoardingAnim.value * 0.08 : _sidebarAnim.value * 0.1),
                  child: Transform.translate(
                    offset: Offset(_sidebarAnim.value * 265, 0), // Geser konten saat sidebar terbuka
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspektif 3D
                        ..rotateY((_sidebarAnim.value * 30) * math.pi / 180), // Rotasi Y
                      child: child,
                    ),
                  ),
                );
              },
              child: _tabBody, // Konten tab yang aktif
            ),
          ),
          // Ikon topi dengan animasi posisi
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                right: (_sidebarAnim.value * -100) + 16, // Bergerak saat sidebar terbuka
                child: child!,
              );
            },
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/samples/images/topi.png', // Gambar ikon topi
                  width: 40,
                  height: 50,
                ),
              ),
            ),
          ),
          // Tombol menu dengan animasi Rive
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: _sidebarAnim.value * 216), // Spacer untuk posisi tombol
                      child!,
                    ],
                  ),
                );
              },
              child: GestureDetector(
                onTap: onMenuPress, // Menangani klik tombol menu
                child: MouseRegion(
                  cursor: SystemMouseCursors.click, // Kursor klik pada desktop
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44 / 2), // Bentuk lingkaran
                      boxShadow: [
                        BoxShadow(
                          color: RiveAppTheme.shadow.withOpacity(0.2), // Bayangan tombol
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: RiveAnimation.asset(
                      app_assets.menuButtonRiv, // File animasi Rive untuk tombol
                      stateMachines: const ["State Machine"],
                      animations: const ["open", "close"],
                      onInit: _onMenuIconInit, // Inisialisasi animasi Rive
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Widget onboarding (tidak aktif saat ini)
          if (_showOnBoarding)
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _onBoardingAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      -(MediaQuery.of(context).size.height +
                              MediaQuery.of(context).padding.bottom) *
                          (1 - _onBoardingAnim.value), // Animasi geser vertikal
                    ),
                    child: child!,
                  );
                },
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 40,
                          offset: const Offset(0, 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Efek gradien di bagian bawah layar
          IgnorePointer(
            ignoring: true, // Tidak menerima input pengguna
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
                builder: (context, child) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          RiveAppTheme.background.withOpacity(0), // Transparan di atas
                          RiveAppTheme.background.withOpacity(
                            1 - (!_showOnBoarding ? _sidebarAnim.value : _onBoardingAnim.value),
                          ), // Opasitas berubah berdasarkan animasi
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Tab bar di bagian bawah
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                !_showOnBoarding ? _sidebarAnim.value * 300 : _onBoardingAnim.value * 200,
              ), // Geser tab bar saat sidebar atau onboarding aktif
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomTabBar(
                onTabChange: (tabIndex) {
                  setState(() {
                    _tabBody = _screens[tabIndex]; // Mengganti konten tab saat tab berubah
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}