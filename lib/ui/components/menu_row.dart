// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor package cupertino untuk widget gaya iOS (CupertinoButton)
import 'package:flutter/cupertino.dart';
// Mengimpor package Rive untuk animasi interaktif
import 'package:rive/rive.dart';
// Mengimpor model data untuk item menu
import 'package:flutter_samples/ui/models/menu_item.dart';
// Mengimpor aset aplikasi, termasuk file Rive
import 'package:flutter_samples/ui/assets.dart' as app_assets;

// Widget untuk menampilkan baris menu di sidebar
class MenuRow extends StatelessWidget {
  const MenuRow({
    Key? key,
    required this.menu, // Data item menu
    this.selectedMenu = "Home", // Menu yang sedang dipilih, default "Home"
    this.onMenuPress, // Callback saat menu diklik
  }) : super(key: key);

  final MenuItemModel menu; // Model data untuk item menu
  final String selectedMenu; // Judul menu yang sedang aktif
  final Function? onMenuPress; // Callback opsional untuk aksi klik

  // Inisialisasi animasi Rive untuk ikon menu
  void _onMenuIconInit(Artboard artboard) {
    // Mengambil state machine dari artboard berdasarkan nama di menu.riveIcon
    final controller = StateMachineController.fromArtboard(
        artboard, menu.riveIcon.stateMachine);
    artboard.addController(controller!);
    // Menyimpan input boolean 'active' ke status riveIcon
    menu.riveIcon.status = controller.findInput<bool>("active") as SMIBool;
  }

  // Fungsi untuk menangani klik pada item menu
  void onMenuPressed() {
    if (selectedMenu != menu.title) { // Hanya jalankan jika menu berbeda dipilih
      onMenuPress!(); // Memanggil callback
      // Mengaktifkan animasi Rive
      menu.riveIcon.status!.change(true);
      // Menonaktifkan animasi setelah 1 detik
      Future.delayed(const Duration(seconds: 1), () {
        menu.riveIcon.status!.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Indikator menu aktif dengan animasi
        AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Durasi animasi
          width: selectedMenu == menu.title ? 288 - 16 : 0, // Lebar penuh saat aktif
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1), // Kurva animasi kustom
          decoration: BoxDecoration(
            color: Colors.blue, // Warna latar belakang indikator
            borderRadius: BorderRadius.circular(10), // Sudut membulat
          ),
        ),
        // Tombol menu
        CupertinoButton(
          padding: const EdgeInsets.all(12), // Padding dalam tombol
          pressedOpacity: 1, // Menonaktifkan efek opasitas saat ditekan
          onPressed: onMenuPressed, // Fungsi saat tombol diklik
          child: Row(
            children: [
              // Ikon animasi Rive
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6, // Opasitas ikon untuk efek visual
                  child: RiveAnimation.asset(
                    app_assets.iconsRiv, // File Rive untuk ikon
                    stateMachines: [menu.riveIcon.stateMachine],
                    artboard: menu.riveIcon.artboard,
                    onInit: _onMenuIconInit, // Inisialisasi animasi
                  ),
                ),
              ),
              const SizedBox(width: 14), // Jarak antar ikon dan teks
              // Judul menu
              Text(
                menu.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter", // Font kustom
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    );
  }
}