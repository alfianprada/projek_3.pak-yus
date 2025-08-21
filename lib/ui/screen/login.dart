import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/home.dart'; // Import halaman Home setelah login berhasil
import 'package:firebase_auth/firebase_auth.dart'; // Package Firebase Authentication
import 'package:flutter_samples/ui/screen/signup.dart'; // Import halaman Sign Up

// Halaman Login utama
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State untuk LoginPage, menggunakan Statefull karena ada animasi + perubahan UI
class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  // Controller untuk mengambil input teks dari user
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Untuk toggle (lihat/sembunyikan password)
  bool _obscurePassword = true;

  // Untuk menampilkan error "Email or password is incorrect"
  bool _showError = false;

  // Controller animasi shake (untuk error)
  late AnimationController _shakeController;
  // Nilai animasi gerakan horizontal saat error
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    // Membuat controller animasi dengan durasi 400ms
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Tween dari 0 ke 10px, lalu dengan efek elasticIn (getar karet)
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    // Hapus controller animasi dari memori
    _shakeController.dispose();
    super.dispose();
  }

  // Fungsi untuk login user dengan Firebase Authentication
  Future<void> loginUser() async {
    setState(() {
      _showError = false; // Reset error saat mencoba login
    });

    try {
      // Coba login menggunakan Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Jika login sukses, arahkan ke Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RiveAppHome()),
      );
    } on FirebaseAuthException catch (_) {
      // Jika login gagal (email/password salah)
      setState(() {
        _showError = true;
      });
      // Jalankan animasi shake pada textfield
      _shakeController.forward(from: 0);
    } catch (e) {
      // Error lain yang tidak terduga
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  // Reusable widget untuk membuat TextField dengan animasi shake
  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          // Geser horizontal jika error (shake)
          offset: Offset(_showError ? _shakeAnimation.value : 0, 0),
          child: TextField(
            controller: controller,
            obscureText: obscureText, // Untuk password
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFD3D3D3), // Background abu-abu
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(vertical: 23, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: _showError ? Colors.red : Colors.transparent, // Border merah jika salah
                  width: 2,
                ),
              ),
              suffixIcon: suffixIcon, // Bisa tambah ikon (misalnya untuk password)
            ),
          ),
        );
      },
    );
  }

  // UI utama halaman login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/samples/images/bgawal.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Agar bisa scroll di layar kecil
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo topi
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/samples/images/topi.png'),
                  ),
                  const SizedBox(height: 10),

                  // Judul aplikasi
                  const Text(
                    'SkillUp!',
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Input email
                  buildTextField(
                    hintText: 'Email',
                    controller: emailController,
                  ),

                  const SizedBox(height: 20),

                  // Input password dengan toggle visibility
                  buildTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; // Toggle sembunyikan password
                        });
                      },
                    ),
                  ),

                  // Jika login gagal → tampilkan error text
                  if (_showError) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Email or password is incorrect',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: loginUser, // Jalankan fungsi login
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

                  const SizedBox(height: 20),

                  // Tombol untuk navigasi ke SignUpPage
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
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
                          'Create Account',
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
      ),
    );
  }
}
