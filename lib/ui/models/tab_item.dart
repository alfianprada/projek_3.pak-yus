// Mengimpor package material dari Flutter untuk widget Material Design (digunakan untuk UniqueKey)
import 'package:flutter/material.dart';
// Mengimpor package Rive untuk mendukung animasi interaktif
import 'package:rive/rive.dart';

// Kelas model untuk item tab dalam tab bar kustom
class TabItem {
  // Konstruktor dengan parameter opsional untuk state machine, artboard, dan status
  TabItem({
    this.stateMachine = "", // Nama state machine di file Rive
    this.artboard = "", // Nama artboard di file Rive
    this.status, // Input boolean untuk mengontrol animasi Rive
  });

  // ID unik untuk setiap item tab, digunakan untuk performa dan manajemen widget
  UniqueKey? id = UniqueKey();
  // Nama state machine dari file Rive untuk animasi tab
  String stateMachine;
  // Nama artboard dari file Rive untuk ikon tab
  String artboard;
  // Status animasi (input boolean dari Rive), diinisialisasi sebagai late
  late SMIBool? status;

  // Daftar statis dari item tab yang digunakan dalam aplikasi
  static List<TabItem> tabItemsList = [
    TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"), // Tab untuk fitur chat
    TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"), // Tab untuk fitur pencarian
    TabItem(stateMachine: "STAR_Interactivity", artboard: "LIKE/STAR"), // Tab untuk fitur timer 
    TabItem(stateMachine: "USER_Interactivity", artboard: "USER"), // Tab untuk fitur akun pengguna
  ];
}