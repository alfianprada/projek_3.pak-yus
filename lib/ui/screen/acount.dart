import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'about_us_page.dart';
import 'security_page.dart';
import 'contact_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

/// Halaman **Account** yang menampilkan informasi akun user
/// serta menu navigasi seperti About Us, Security, Contact Us, dan Logout.
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Ambil user yang sedang login dari FirebaseAuth
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2, // Warna background luar
      child: Center(
        child: Container(
          // Kotak utama dengan radius melengkung
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                /// Judul halaman
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                /// Ikon avatar user
                const Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.black,
                  ),
                ),

                /// Menampilkan nama user / guest
                Center(
                  child: user == null
                      // Kalau user belum login → tampilkan Guest
                      ? const Text(
                          "Guest",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      // Kalau user sudah login → ambil data dari Firestore
                      : StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid) // Ambil dokumen sesuai UID
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            // Ambil data user dari Firestore
                            final data = snapshot.data!.data() as Map<String, dynamic>?;
                            final username =
                                data?['username'] ?? user!.email ?? "Guest";

                            return Text(
                              username,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),

                /// List menu navigasi
                Expanded(
                  child: ListView(
                    children: [
                      // Menu About Us
                      _buildTile(
                        context,
                        "About Us",
                        Icons.info,
                        const Color(0xFF7850F0),
                        const AboutUsPage(),
                      ),
                      // Menu Security
                      _buildTile(
                        context,
                        "Security",
                        Icons.security,
                        const Color(0xFF6792FF),
                        const SecurityPage(),
                      ),
                      // Menu Contact Us
                      _buildTile(
                        context,
                        "Contact Us",
                        Icons.contact_support,
                        const Color(0xFFBBA6FF),
                        const ContactUsPage(),
                      ),
                      // Menu Logout
                      _buildTile(
                        context,
                        "Log out",
                        Icons.logout,
                        const Color(0xFF9CC5FF),
                        null,
                        isLogout: true, // Flag khusus logout
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk membuat menu kotak (tile) dengan icon, title, dan navigasi
  Widget _buildTile(
    BuildContext context,
    String title,
    IconData leadingIcon,
    Color color,
    Widget? page, {
    bool isLogout = false, // apakah tombol ini untuk logout
  }) {
    return GestureDetector(
      onTap: () async {
        if (isLogout) {
          // Jika tombol logout ditekan → signOut dari Firebase
          try {
            await FirebaseAuth.instance.signOut();

            // Setelah logout, arahkan ke halaman login
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false, // hapus semua route sebelumnya
            );
          } catch (e) {
            // Jika gagal logout → tampilkan pesan error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: $e')),
            );
          }
        } else if (page != null) {
          // Jika bukan logout → navigasi ke halaman tujuan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            // Ikon di kiri
            Icon(leadingIcon, size: 26, color: Colors.white),
            const SizedBox(width: 16),

            // Teks judul menu
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Panah kecil di kanan
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
