import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [
              Shadow(
                color: Colors.pinkAccent,
                offset: Offset(0, 0),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background Cyberpunk Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF6A0DAD), Color(0xFFFF007F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Icon(
                      Icons.contact_mail,
                      size: 100,
                      color: Colors.cyanAccent.withOpacity(0.7),
                      shadows: const [
                        Shadow(
                          color: Colors.pinkAccent,
                          offset: Offset(0, 0),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Reach Out in Style!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      shadows: [
                        Shadow(
                          color: Colors.pinkAccent,
                          offset: Offset(0, 0),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Questions, feedback, or just want to say hi? Hit us up below – "
                    "we love connecting with our awesome users in the coolest way possible!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 30),

                  // Contact Info Cards
                  _neonCard(
                    icon: Icons.email,
                    iconColor: Colors.cyanAccent,
                    title: "Email",
                    subtitle: "support@skillup.com",
                  ),
                  const SizedBox(height: 16),
                  _neonCard(
                    icon: Icons.phone,
                    iconColor: Colors.greenAccent,
                    title: "Phone",
                    subtitle: "+62 812-3456-7890",
                  ),
                  const SizedBox(height: 16),
                  _neonCard(
                    icon: Icons.location_on,
                    iconColor: Colors.pinkAccent,
                    title: "Address",
                    subtitle: "Jl. Pendidikan No. 123, Jakarta, Indonesia",
                  ),
                  const SizedBox(height: 40),

                  // Chat Button Neon Style
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        backgroundColor: Colors.black.withOpacity(0.3),
                        shadowColor: Colors.cyanAccent,
                        elevation: 12,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.chat, color: Colors.cyanAccent),
                      label: const Text(
                        "Chat with Support",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.pinkAccent,
                              blurRadius: 8,
                            )
                          ],
                        ),
                      ),
                      onPressed: () async {
                        final phone = '+6282257173325';
                        final message = Uri.encodeComponent("Halo SkillUp, saya ingin bertanya...");
                        final url = 'https://wa.me/$phone?text=$message';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open WhatsApp')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _neonCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: iconColor.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [
                          Shadow(color: iconColor.withOpacity(0.7), blurRadius: 10)
                        ],
                      )),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
