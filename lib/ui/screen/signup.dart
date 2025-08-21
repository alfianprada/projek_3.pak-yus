import 'package:flutter/material.dart';             // ✅ UI utama Flutter
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Database NoSQL Firebase untuk simpan data tambahan
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Autentikasi Firebase (email & password)
import 'package:flutter_samples/ui/home.dart';     // ✅ Halaman utama setelah login
import 'package:flutter_samples/ui/screen/login.dart'; // ✅ Halaman login

// 📌 Halaman untuk Sign Up (daftar akun baru)
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // 🔹 Controller untuk mengambil input dari user (username, email, password)
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 🔹 Menandakan sedang loading (misalnya saat proses daftar)
  bool _isLoading = false;

  // 📌 Fungsi untuk sign up user baru
  Future<void> _signUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 🔹 Validasi input (cek kalau masih kosong)
    if (username.isEmpty) {
      _showMessage("Username cannot be empty");
      return;
    }
    if (email.isEmpty) {
      _showMessage("Email cannot be empty");
      return;
    }
    if (password.isEmpty) {
      _showMessage("Password cannot be empty");
      return;
    }

    // 🔹 Ganti tombol jadi loading
    setState(() => _isLoading = true);

    try {
      // 🔹 Buat user baru di Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔹 Simpan data tambahan (username & email) di Firestore
      await FirebaseFirestore.instance
          .collection('users')                  // koleksi "users"
          .doc(userCredential.user!.uid)        // pakai UID dari FirebaseAuth
          .set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),           // waktu daftar
      });

      if (!mounted) return;

      // 🔹 Kalau berhasil daftar → pindah ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RiveAppHome()),
      );
    } on FirebaseAuthException catch (e) {
      // 🔹 Tangani error dari FirebaseAuth
      String message = "Sign-up failed. Please try again.";
      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      } else if (e.code == 'invalid-email') {
        message = "The email format is invalid.";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters.";
      }
      _showMessage(message);
    } catch (e) {
      // 🔹 Tangani error umum
      _showMessage("Something went wrong. Please try again later.");
    } finally {
      // 🔹 Setelah semua proses selesai → matikan loading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 📌 Fungsi untuk menampilkan pesan snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 📌 Tampilan background
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/samples/images/bgawal.png'), // gambar background
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Logo di atas
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('assets/samples/images/topi.png'),
                ),
                const Text(
                  'SkillUp!',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Input Username
                TextField(
                  controller: _usernameController,
                  decoration: _inputDecoration("Username"),
                ),
                const SizedBox(height: 10),

                // 🔹 Input Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Email"),
                ),
                const SizedBox(height: 10),

                // 🔹 Input Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _inputDecoration("Password"),
                ),
                const SizedBox(height: 20),

                // 🔹 Tombol Sign Up
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _signUp, // kalau loading, tombol disable
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white) // loading indicator
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Inter",
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Tombol untuk pindah ke Login
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4B5EAA), Color(0xFF8A4AF3)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Inter",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📌 Styling untuk input text
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFD3D3D3),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 23, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
