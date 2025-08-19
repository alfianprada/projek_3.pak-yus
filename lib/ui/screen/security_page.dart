import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCurrentUsername();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  Future<void> _loadCurrentUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _usernameController.text = doc.data()?['username'] ?? '';
      setState(() {});
    }
  }

  Future<void> _updateUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      _showMessage('Username cannot be empty');
      return;
    }

    // Update atau buat field username baru
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': newUsername,
    }, SetOptions(merge: true)); // merge:true → buat field baru jika belum ada

    _showMessage('Username updated!');
  }

  Future<void> _updatePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      _showMessage('Fill all password fields');
      return;
    }
    if (newPassword.length < 6) {
      _showMessage('New password must be at least 6 characters');
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      _showMessage('Password updated!');
      _oldPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      _showMessage('Failed to update password: $e');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Security Settings',
          style: TextStyle(
            color: Color.fromRGBO(147, 112, 219, 1),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 6,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(147, 112, 219, 1),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D0D2B), Color(0xFF4B0082)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Icon(
                        Icons.security,
                        size: 100,
                        color: const Color.fromRGBO(147, 112, 219, 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Secure Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Update your username and password to keep your account safe.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _staggeredCard(children: [
                      _buildTextField(_usernameController, 'Username', Icons.person),
                      const SizedBox(height: 16),
                      _neonButton('Update Username', _updateUsername, Icons.person),
                    ]),
                    const SizedBox(height: 30),
                    _staggeredCard(children: [
                      _buildTextField(_oldPasswordController, 'Old Password', Icons.lock,
                          obscure: true),
                      const SizedBox(height: 16),
                      _buildTextField(_newPasswordController, 'New Password',
                          Icons.lock_outline,
                          obscure: true),
                      const SizedBox(height: 16),
                      _neonButton('Update Password', _updatePassword, Icons.lock),
                    ]),
                    const SizedBox(height: 50),
                    const Text(
                      '💡 Tip: Change your password regularly and keep your credentials confidential.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _staggeredCard({required List<Widget> children}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: _glassCard(children: children),
          ),
        );
      },
    );
  }

  Widget _glassCard({required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromRGBO(147, 112, 219, 1)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _neonButton(String text, VoidCallback onPressed, IconData icon) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: const Color.fromRGBO(147, 112, 219, 1)),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.15),
        shadowColor: const Color.fromRGBO(147, 112, 219, 1),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
