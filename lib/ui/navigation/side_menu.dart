// Mengimpor package cupertino untuk widget gaya iOS (meskipun tidak terlihat digunakan)
import 'package:flutter/cupertino.dart';
// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
// Mengimpor package Rive untuk animasi interaktif
import 'package:rive/rive.dart';
// Mengimpor komponen MenuRow untuk menampilkan item menu
import 'package:flutter_samples/ui/components/menu_row.dart';
// Mengimpor model data untuk item menu
import 'package:flutter_samples/ui/models/menu_item.dart';
// Mengimpor definisi tema aplikasi
import 'package:flutter_samples/ui/theme.dart';
// Mengimpor aset aplikasi (kemungkinan path file Rive atau gambar)
import 'package:flutter_samples/ui/assets.dart' as app_assets;

// Widget untuk sidebar menu aplikasi
class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

// State untuk SideMenu, mengelola status menu dan tema
class _SideMenuState extends State<SideMenu> {
  // Daftar item menu untuk bagian "BROWSE"
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  // Daftar item menu untuk bagian "HISTORY"
  // final List<MenuItemModel> _historyMenuIcons = MenuItemModel.menuItems2;
  // Menyimpan judul menu yang sedang dipilih, default ke menu pertama
  String _selectedMenu = MenuItemModel.menuItems[0].title;
  // Status tema gelap (tidak digunakan dalam build saat ini)
  bool _isDarkMode = false;

  // Fungsi untuk menangani klik pada item menu
  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title; // Memperbarui menu yang dipilih
    });
  }

  // Fungsi untuk menangani perubahan toggle tema (tidak digunakan dalam UI saat ini)
  void onThemeToggle(value) {
    setState(() {
      _isDarkMode = value; // Memperbarui status tema gelap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding menyesuaikan dengan safe area (status bar dan navigation bar)
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom - 60),
      // Membatasi lebar maksimum sidebar
      constraints: const BoxConstraints(maxWidth: 288),
      // Dekorasi sidebar dengan warna tema dan sudut membulat
      decoration: BoxDecoration(
        color: RiveAppTheme.background2, // Warna latar belakang biru tua
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Konten rata kiri
        children: [
          // Bagian profil pengguna
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar pengguna
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2), // Latar avatar transparan
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline), // Ikon profil default
                ),
                const SizedBox(width: 8), // Jarak antar avatar dan teks
                // Informasi pengguna
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama atau kelas pengguna
                    const Text(
                      "XII RPL 1",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: "Inter"), // Font kustom
                    ),
                    const SizedBox(height: 2), // Jarak antar teks
                    // Deskripsi pengguna
                    Text(
                      "Software Engineer",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), // Teks dengan opasitas
                          fontSize: 15,
                          fontFamily: "Inter"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bagian menu yang dapat di-scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Seksi menu "BROWSE"
                  MenuButtonSection(
                      title: "BROWSE",
                      selectedMenu: _selectedMenu,
                      menuIcons: _browseMenuIcons,
                      onMenuPress: onMenuPress),
                  // Seksi menu "HISTORY"
                  // MenuButtonSection(
                  //     title: "HISTORY",
                  //     selectedMenu: _selectedMenu,
                  //     menuIcons: _historyMenuIcons,
                  //     onMenuPress: onMenuPress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan seksi menu (BROWSE atau HISTORY)
class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    Key? key,
    required this.title,
    required this.menuIcons,
    this.selectedMenu = "Home", // Default menu yang dipilih
    this.onMenuPress,
  }) : super(key: key);

  final String title; // Judul seksi (BROWSE atau HISTORY)
  final String selectedMenu; // Menu yang sedang dipilih
  final List<MenuItemModel> menuIcons; // Daftar item menu
  final Function(MenuItemModel menu)? onMenuPress; // Callback saat menu diklik

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Konten rata kiri
      children: [
        // Judul seksi
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.7), // Teks dengan opasitas
                fontSize: 15,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600),
          ),
        ),
        // Daftar item menu
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Iterasi melalui daftar menuIcons
              for (var menu in menuIcons) ...[
                // Garis pemisah antar item
                Divider(
                    color: Colors.white.withOpacity(0.1),
                    thickness: 1,
                    height: 1,
                    indent: 16,
                    endIndent: 16),
                // Item menu menggunakan widget MenuRow
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress!(menu), // Panggil callback saat diklik
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}