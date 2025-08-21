import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient; 
// Import Rive untuk animasi vektor (ikon tab animasi)

import 'package:flutter_samples/ui/models/tab_item.dart';
// Model TabItem yang menyimpan data tiap tab (artboard, state machine, dll)

import 'package:flutter_samples/ui/theme.dart';
// Tema khusus aplikasi (misalnya warna)

import 'package:flutter_samples/ui/assets.dart' as app_assets;
// Akses ke file assets (misalnya .riv untuk ikon animasi)

// Widget utama custom bottom tab bar
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key? key,
    required this.onTabChange, // Callback ketika tab diganti
    this.currentIndex = 0, // Indeks tab yang aktif saat pertama kali
  }) : super(key: key);

  final Function(int tabIndex) onTabChange; // Event untuk memberi tahu parent tab mana yg dipilih
  final int currentIndex; // Menyimpan tab yang sedang aktif (default 0)

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItemsList; 
  // Daftar tab dari model TabItem (isi: ikon Rive, artboard, stateMachine, dll)
  
  late int _selectedTab; 
  // Menyimpan index tab yang aktif saat ini

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.currentIndex; 
    // Saat widget pertama kali dibuat, set tab aktif sesuai currentIndex
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fungsi ini dipanggil ketika parent me-render ulang CustomTabBar
    // Misalnya parent ganti currentIndex, maka tab ikut update
    if (widget.currentIndex != _selectedTab) {
      setState(() {
        _selectedTab = widget.currentIndex;
      });
    }
  }

  // Fungsi untuk inisialisasi animasi Rive pada tiap ikon
  void _onRiveIconInit(Artboard artboard, int index) {
    final controller =
        StateMachineController.fromArtboard(artboard, _icons[index].stateMachine);
    artboard.addController(controller!);

    // Cari input boolean "active" pada stateMachine untuk kontrol animasi
    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  // Fungsi yang dipanggil ketika tab ditekan
  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index; // Ubah tab aktif
      });
      widget.onTabChange(index); // Kirim event ke parent
      _icons[index].status!.change(true); // Aktifkan animasi Rive
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status!.change(false); // Matikan animasi setelah 1 detik
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(1),
        constraints: const BoxConstraints(maxWidth: 768),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0)
          ]),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: RiveAppTheme.background2.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: RiveAppTheme.background2.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              TabItem icon = _icons[index];
              return Expanded(
                key: icon.id, // Gunakan id unik tiap tab
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedOpacity(
                    // Efek transparansi jika tab tidak aktif
                    opacity: _selectedTab == index ? 1 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Garis indikator di atas tab yang aktif
                        Positioned(
                          top: -4,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 4,
                            width: _selectedTab == index ? 20 : 0,
                            decoration: BoxDecoration(
                              color: RiveAppTheme.accentColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Ikon animasi dari file Rive
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: RiveAnimation.asset(
                            app_assets.iconsRiv, // Lokasi file .riv
                            stateMachines: [icon.stateMachine], // StateMachine yg dipakai
                            artboard: icon.artboard, // Artboard yg dipilih
                            onInit: (artboard) => _onRiveIconInit(artboard, index),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () => onTabPress(index), // Tekan tab
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
