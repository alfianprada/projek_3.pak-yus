// Mengimpor package material dari Flutter untuk widget Material Design (digunakan untuk UniqueKey)
import 'package:flutter/material.dart';
// Mengimpor model data untuk item tab (ikon Rive)
import 'package:flutter_samples/ui/models/tab_item.dart';

// Kelas model untuk item menu dalam sidebar
class MenuItemModel {
  // Konstruktor dengan parameter opsional untuk id dan title, serta riveIcon wajib
  MenuItemModel({
    this.id,
    this.title = "", // Default title kosong
    required this.riveIcon, // Ikon Rive untuk item menu
  });

  // ID unik untuk setiap item menu, digunakan untuk performa dan manajemen widget
  UniqueKey? id = UniqueKey();
  // Judul item menu
  String title;
  // Ikon animasi Rive yang terkait dengan item menu
  TabItem riveIcon;

  // Daftar item menu untuk bagian "BROWSE" di sidebar
  static List<MenuItemModel> menuItems = [
    MenuItemModel(
      title: "Home",
      riveIcon: TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"), // Menu untuk beranda
    ),
    MenuItemModel(
      title: "Search",
      riveIcon:
          TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"), // Menu untuk pencarian
    ),
    MenuItemModel(
      title: "Add Courses ",
      riveIcon:
          TabItem(stateMachine: "STAR_Interactivity", artboard: "LIKE/STAR"), // Menu untuk favorit
    ),
    MenuItemModel(
      title: "Account",
      riveIcon: TabItem(stateMachine: "USER_Interactivity", artboard: "USER"), // Menu untuk riwayat
    ), 
    MenuItemModel(
      title: "Help",
      riveIcon: TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"), // Menu untuk bantuan
    ),
  ];

  // Daftar item menu untuk bagian "HISTORY" di sidebar
  // static List<MenuItemModel> menuItems2 = [
  //   MenuItemModel(
  //     title: "Account",
  //     riveIcon: TabItem(stateMachine: "USER_Interactivity", artboard: "USER"), // Menu untuk riwayat
  //   ), 
  //   MenuItemModel(
  //     title: "Notification",
  //     riveIcon: TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"), // Menu untuk notifikasi
  //   ),
  // ];
}