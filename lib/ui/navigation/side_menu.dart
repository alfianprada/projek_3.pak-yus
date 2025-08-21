import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk cek user yang sedang login (UID dsb.)
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk membaca username live dari koleksi 'users'
import 'package:flutter_samples/ui/screen/contact_us_page.dart'; // Halaman Contact Us dipanggil dari Help popup
import '../components/menu_row.dart'; // Komponen baris menu (icon + teks)
import '../models/menu_item.dart'; // Model / list menu (MenuItemModel.menuItems)
import '../theme.dart'; // Tema aplikasi (warna background, shadow, dsb.)

/*
  SideMenu (drawer kustom)
  - Menampilkan profil pengguna (username diambil realtime dari Firestore)
  - Menampilkan daftar menu (MenuItemModel.menuItems)
  - Menangani aksi saat user memilih menu:
    • Menutup menu (closeMenu callback)
    • Memanggil onTabChange(index) untuk mengganti tab di parent
    • Menampilkan popup Help (bila dipilih)
*/
class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    required this.onTabChange,   // Callback untuk memberitahu parent ganti tab (index)
    required this.closeMenu,     // Callback untuk menutup menu (biasanya trigger animasi)
    this.selectedTabIndex = 0,   // index tab yang sedang aktif (opsional)
  });

  final Function(int index) onTabChange;
  final VoidCallback closeMenu;
  final int selectedTabIndex;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Ambil daftar menu dari model (harus didefinisikan di models/menu_item.dart)
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;

  // Nama menu yang sedang dipilih (untuk highlight)
  String _selectedMenu = MenuItemModel.menuItems[0].title;

  // Dipanggil saat user menekan salah satu item menu
  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title; // update highlight
    });

    // Tutup dulu menu (callback ke parent supaya animasi tutup berjalan)
    widget.closeMenu();

    // Routing/aksi berdasarkan judul menu (perhatikan: ini sensitif terhadap perubahan string)
    switch (menu.title) {
      case "Help":
        _showHelpDialog(); // tampilkan popup bantuan
        return; // berhenti supaya tidak men-trigger tab change
      case "Home":
        widget.onTabChange(0);
        break;
      case "Search":
        widget.onTabChange(1);
        break;
      case "Add Courses":
        widget.onTabChange(2);
        break;
      case "Account":
        widget.onTabChange(3);
        break;
    }
  }

  // Dialog bantuan (Help). Menggunakan showDialog + Dialog kustom.
  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // bisa ditutup dengan tap di luar dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEDE6FF),
                  Color(0xFFEAF1FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // dialog mengecil mengikuti konten
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header dialog: judul + tombol tutup
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Need Help?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(context), // tutup dialog
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Penjelasan singkat
                const Text(
                  "We’re here to help you learn without obstacles!\n\n"
                  "Find answers to common questions, step-by-step guides, or contact our team if you need further assistance.",
                  style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Subbagian User Guide
                const Text(
                  "User Guide",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• How to easily enroll in a course\n"
                  "• Accessing learning materials and videos\n"
                  "• Tracking your learning progress\n"
                  "• Earning certificates after completing a course",
                  style: TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Tombol Contact Us (buka halaman ContactUsPage)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactUsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Contact Us"),
                ),
                const SizedBox(height: 16),

                // Informasi kontak statis
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "📧 Email: support@courseapp.com\n"
                    "📸 Instagram: @excellion_\n"
                    "📞 Phone: +62 812 3456 7890",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil user Firebase saat ini (bisa null jika belum login)
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      // Padding atas/bawah memperhitungkan safe area (status bar & bottom inset)
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: MediaQuery.of(context).padding.bottom - 60,
      ),
      constraints: const BoxConstraints(maxWidth: 288), // lebar drawer tetap
      decoration: BoxDecoration(
        color: RiveAppTheme.background2, // warna dari theme custom
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section profil: avatar + username (username diambil realtime dari Firestore)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha((0.2 * 255).round()),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 8),

                // Ambil username secara realtime dengan StreamBuilder
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      // Jika user == null, gunakan stream kosong agar StreamBuilder tidak error
                      stream: user != null
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .snapshots()
                          : const Stream.empty(),
                      builder: (context, snapshot) {
                        // Tampilkan loading saat menunggu data
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            "Loading...",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          );
                        }
                        // Jika tidak ada data (dokumen tidak ada atau user null)
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text(
                            "None",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          );
                        }
                        // Ambil field 'username' dengan fallback
                        // NOTE: gunakan .get('username') karena kita yakin dokumen ada,
                        // tapi bila field tak ada, bisa menimbulkan error — pertimbangkan pengecekan tambahan.
                        final username = snapshot.data!.get('username') ?? "None";
                        return Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "Inter",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bagian menu (scrollable jika banyak item)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Section untuk kumpulan tombol menu (BROWSE dll.)
                  MenuButtonSection(
                    title: "BROWSE",
                    selectedMenu: _selectedMenu,
                    menuIcons: _browseMenuIcons,
                    onMenuPress: onMenuPress, // passed callback ke MenuRow
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
  Komponen kecil: MenuButtonSection
  - Menerima list MenuItemModel (menuIcons) dan membangunnya
  - Menampilkan header ('BROWSE') lalu iterasi menu
  - Menggunakan MenuRow (komponen presentasi tiap baris menu)
*/
class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection({
    super.key,
    required this.title,
    required this.menuIcons,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section (label)
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withAlpha((0.7 * 255).round()),
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Container yang menampung daftar menu
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              // Loop setiap item menu, tampilkan divider + MenuRow
              for (var menu in menuIcons) ...[
                Divider(
                  color: Colors.white.withAlpha((0.1 * 255).round()),
                  thickness: 1,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  onMenuPress: () => onMenuPress!(menu), // panggil callback saat ditekan
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
