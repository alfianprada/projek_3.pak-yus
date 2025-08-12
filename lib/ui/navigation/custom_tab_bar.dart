// Mengimpor package cupertino untuk widget gaya iOS (CupertinoButton)
import 'package:flutter/cupertino.dart';
// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor package Rive untuk animasi interaktif, dengan pengecualian LinearGradient
import 'package:rive/rive.dart' hide LinearGradient;
// Mengimpor model data untuk item tab
import 'package:flutter_samples/ui/models/tab_item.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';
// Mengimpor aset aplikasi, termasuk file Rive
import 'package:flutter_samples/ui/assets.dart' as app_assets;

// Widget untuk tab bar kustom dengan animasi Rive
class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key, required this.onTabChange}) : super(key: key);

  // Callback untuk menangani perubahan tab
  final Function(int tabIndex) onTabChange;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

// State untuk CustomTabBar, mengelola status tab dan animasi
class _CustomTabBarState extends State<CustomTabBar> {
  // Daftar item tab dari model TabItem
  final List<TabItem> _icons = TabItem.tabItemsList;
  // Indeks tab yang sedang dipilih
  int _selectedTab = 0;

  // Inisialisasi animasi Rive untuk ikon tab
  void _onRiveIconInit(Artboard artboard, index) {
    // Mengambil state machine dari artboard berdasarkan nama di TabItem
    final controller = StateMachineController.fromArtboard(
        artboard, _icons[index].stateMachine);
    artboard.addController(controller!);
    // Menyimpan input boolean 'active' dari state machine ke model TabItem
    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  // Fungsi untuk menangani klik pada tab
  void onTabPress(int index) {
    if (_selectedTab != index) { // Hanya jalankan jika tab berbeda dipilih
      setState(() {
        _selectedTab = index; // Memperbarui tab yang dipilih
      });
      widget.onTabChange(index); // Memanggil callback untuk mengganti konten
      // Mengaktifkan animasi Rive untuk tab yang dipilih
      _icons[index].status!.change(true);
      // Menonaktifkan animasi setelah 1 detik
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status!.change(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // Margin untuk jarak dari tepi layar
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(1),
        // Membatasi lebar maksimum tab bar
        constraints: const BoxConstraints(maxWidth: 768),
        // Dekorasi luar dengan gradien transparan
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0)
          ]),
        ),
        child: Container(
          // Memotong konten di luar batas border
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: RiveAppTheme.background2.withOpacity(0.8), // Latar belakang biru tua
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: RiveAppTheme.background2.withOpacity(0.3), // Bayangan
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Ikon merata
            children: List.generate(_icons.length, (index) {
              TabItem icon = _icons[index];

              return Expanded(
                key: icon.id, // Key unik untuk performa
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedOpacity(
                    // Mengatur opasitas berdasarkan tab yang dipilih
                    opacity: _selectedTab == index ? 1 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Indikator tab aktif (garis kecil di atas ikon)
                        Positioned(
                          top: -4,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 4,
                            width: _selectedTab == index ? 20 : 0, // Lebar berubah
                            decoration: BoxDecoration(
                              color: RiveAppTheme.accentColor, // Warna aksen
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Ikon animasi Rive
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: RiveAnimation.asset(
                            app_assets.iconsRiv, // File Rive untuk ikon
                            stateMachines: [icon.stateMachine],
                            artboard: icon.artboard,
                            onInit: (artboard) {
                              _onRiveIconInit(artboard, index); // Inisialisasi animasi
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    onTabPress(index); // Menangani klik tab
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}