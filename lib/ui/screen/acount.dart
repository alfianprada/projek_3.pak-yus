import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'about_us_page.dart';
import 'security_page.dart';
import 'contact_us_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
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
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: user == null
                      ? const Text(
                          "Guest",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
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
                Expanded(
                  child: ListView(
                    children: [
                      _buildTile(
                        context,
                        "About Us",
                        Icons.info,
                        const Color(0xFF7850F0),
                        const AboutUsPage(),
                      ),
                      _buildTile(
                        context,
                        "Security",
                        Icons.security,
                        const Color(0xFF6792FF),
                        const SecurityPage(),
                      ),
                      _buildTile(
                        context,
                        "Contact Us",
                        Icons.contact_support,
                        const Color(0xFFBBA6FF),
                        const ContactUsPage(),
                      ),
                      _buildTile(
                        context,
                        "Log out",
                        Icons.logout,
                        const Color(0xFF9CC5FF),
                        null,
                        isLogout: true,
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

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData leadingIcon,
    Color color,
    Widget? page, {
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isLogout) {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: $e')),
            );
          }
        } else if (page != null) {
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
            Icon(leadingIcon, size: 26, color: Colors.white),
            const SizedBox(width: 16),
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
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}
